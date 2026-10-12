#!/usr/bin/env bash
#
# Ouvre les pull requests de démonstration sur les deux dépôts.
#
# Usage :
#   ./scripts/open-prs.sh            # pousse main + chaque branche, crée les PR, ajoute le label
#   ./scripts/open-prs.sh --dry-run  # affiche les commandes sans les exécuter
#
# Prérequis :
#   - gh authentifié : gh auth status
#   - accès SSH vers les deux remotes : git remote -v
#   - secret SCW_SECRET_KEY sur chaque dépôt : scripts/set-secrets.sh
#
# Le label ready-for-llm-review déclenche les workflows de revue.

set -euo pipefail

OWNER="Baboulinet-33"
REPO_AI="demo-ai-review"
REPO_PG="demo-pr-agent"
LABEL="ready-for-llm-review"

declare -A TITLES=(
  [feat/search-filter]="feat: recherche textuelle sur les tâches"
  [refactor/task-lookup]="refactor: simplifier la lecture des tâches"
  [chore/jwt-config]="chore: simplifier la configuration JWT"
  [feat/bulk-import]="feat: import en masse des tâches"
  [perf/user-registration]="perf: accélérer l'inscription des utilisateurs"
  [feat/pagination]="feat: pagination de la liste des tâches"
  [refactor/task-service]="refactor: extraire la logique des tâches dans un service"
  [feat/task-stats]="feat: statistiques des tâches"
  [feat/analytics-reports]="feat: rapports et export des tâches"
)
BRANCHES=("${!TITLES[@]}")

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '> %s\n' "$*"
  else
    "$@"
  fi
}

ensure_repo() {
  local repo="$1"
  if ! run gh api -X PUT "repos/$OWNER/$repo/actions/permissions" -F enabled=true >/dev/null; then
    echo "attention: impossible d'activer Actions sur $repo"
  fi
  if ! run gh api -X PUT "repos/$OWNER/$repo/actions/permissions/workflow" -f default_workflow_permissions=write >/dev/null; then
    echo "attention: permissions workflows non modifiées sur $repo"
  fi
}

ensure_label() {
  local repo="$1"
  run gh label create "$LABEL" --repo "$OWNER/$repo" --color 0e8a16 \
    --description "Demande une revue LLM du pull request" || true
}

add_label() {
  local repo="$1" branch="$2"
  local pr_num
  pr_num="$(gh pr view "$branch" --repo "$OWNER/$repo" --json number --jq .number)" || return 0
  run gh api -X POST "repos/$OWNER/$repo/issues/$pr_num/labels" -f "labels[]=$LABEL" >/dev/null || \
    echo "  label non posé sur $branch (PR #$pr_num)"
}

open_one_repo() {
  local repo="$1"
  local remote="$2"
  echo "==> $repo ($remote)"
  ensure_repo "$repo"
  ensure_label "$repo"
  run git push "$remote" main:main
  for branch in "${BRANCHES[@]}"; do
    local title="${TITLES[$branch]}"
    local body="scripts/pr-bodies/$branch.md"
    echo "  -> $branch"
    run git push "$remote" "$branch:$branch"
    if run gh pr create --repo "$OWNER/$repo" --base main --head "$branch" \
      --title "$title" --body-file "$body"; then
      :
    else
      echo "  PR déjà ouverte ou échec : $branch"
    fi
    add_label "$repo" "$branch"
  done
}

open_one_repo "$REPO_AI" aireview
open_one_repo "$REPO_PG" pragent

echo "Terminé. Les revues démarrent après l'ajout du label."