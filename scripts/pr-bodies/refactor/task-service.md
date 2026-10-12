## Description

Déplace la logique des tâches dans un module de service séparé de la couche de routes.

La couche de routes ne contient plus que les endpoints. Le module `app/task_service.py` centralise les opérations de lecture et d'écriture.

Ensuite, la couche de stockage pourra être remplacée sans toucher aux routes.