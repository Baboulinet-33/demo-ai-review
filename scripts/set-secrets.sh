#!/usr/bin/env bash
#
# Dépose le secret SCW_SECRET_KEY sur les deux dépôts.
#
# Usage :
#   SCW_SECRET_KEY=clé_scaleway ./scripts/set-secrets.sh
#
# La clé vient de la console Scaleway, section IAM > API keys.

set -euo pipefail

OWNER="Baboulinet-33"
: "${SCW_SECRET_KEY:?Définissez SCW_SECRET_KEY dans l'environnement}"

for repo in demo-ai-review demo-pr-agent; do
  echo "==> $repo"
  gh secret set SCW_SECRET_KEY --repo "$OWNER/$repo" --body "$SCW_SECRET_KEY"
done

echo "Secret déposé sur les deux dépôts."