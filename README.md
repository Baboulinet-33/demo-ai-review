# TaskFlow API

API de gestion de tâches. L'API utilise FastAPI, une authentification JWT et un stockage en mémoire.

## Fonctions

- Inscription et connexion : `/auth/register` et `/auth/login`.
- Création, lecture, mise à jour et suppression des tâches.
- Filtrage des tâches par statut.
- Chaque utilisateur lit seulement ses propres tâches.

Les données restent en mémoire. Un redémarrage supprime toutes les tâches.

## Prérequis

- Python 3.10 ou plus récent.
- pip.

## Installation

1. Créez un environnement virtuel.

   ```bash
   python -m venv .venv
   ```

2. Activez l'environnement virtuel.

   ```bash
   source .venv/bin/activate
   ```

3. Installez l'application et les dépendances de test.

   ```bash
   pip install -e ".[dev]"
   ```

## Lancer l'API

Lancez le serveur de développement.

```bash
uvicorn app.main:app --reload
```

La documentation de l'API se trouve sur `http://127.0.0.1:8000/docs`.

## Lancer les tests

```bash
pytest
```

## Configuration

L'API lit le secret JWT dans la variable d'environnement `JWT_SECRET`. Sans cette variable, l'API utilise un secret de développement.

## Revue automatique des pull requests

Deux outils de revue analysent les pull requests.

- `ai-review` est actif dans le dépôt `demo-ai-review`.
- `pr-agent` est actif dans le dépôt `demo-pr-agent`.

Une revue démarre quand vous ajoutez le label `ready-for-llm-review` à une pull request.

### Secrets

Ajoutez le secret `SCW_SECRET_KEY` dans chaque dépôt, sous `Settings > Secrets and variables > Actions`. La valeur est une clé d'API Scaleway.

GitHub fournit le jeton `GITHUB_TOKEN` automatiquement.
