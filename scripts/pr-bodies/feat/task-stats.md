## Description

Ajoute l'endpoint `GET /tasks/stats` pour l'utilisateur connecté.

La réponse contient le nombre total de tâches, le décompte par statut et le taux de complétion.

Exemple de réponse :

```json
{
  "total": 2,
  "by_status": {"todo": 1, "doing": 0, "done": 1},
  "completion_rate": 0.5
}
```

Un test couvre le nouvel endpoint.