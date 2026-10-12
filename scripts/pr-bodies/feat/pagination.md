## Description

Ajoute la pagination de la liste des tâches.

Le nouvel endpoint `GET /tasks/page` prend deux paramètres :

- `offset` : position de départ.
- `limit` : nombre de tâches par page.

La réponse contient les éléments de la page, le total et le nombre de pages.

Exemple : avec 5 tâches et `limit=2`, la réponse donne `total: 5` et `pages: 3`.

## Tests

La suite de tests reste verte.