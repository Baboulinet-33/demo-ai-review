## Objectif

Ajouter une première brique de reporting à l'API : agrégation par fenêtre
(jour, semaine, mois), export CSV et JSON, filtres sur le résumé et
planification d'exports récurrents.

## Changements

- `app/analytics.py` : agrégations (totaux, taux de complétion, percentiles,
  séries par jour).
- `app/filters.py` : petit langage de filtre du type `status:done&priority:high`
  pour le résumé.
- `app/export.py` : export CSV et JSON, avec réessai sur échec.
- `app/scheduler.py` : planificateur interne pour les exports récurrents.
- `app/security.py` : jeton signé pour les liens d'export.
- Nouveaux endpoints : `/reports/summary`, `/reports/export`,
  `/reports/export-token`, `/reports/schedule` et `/reports/metrics`.
- Tests : couverture des agrégations, des filtres, de l'export et des endpoints.

## Notes

Le PR est dense : il touche le modèle, le stockage, la sécurité et l'API d'un
coup. Les changements restent rétro-compatibles et toute la suite de tests
passe. Le planificateur vit en mémoire, comme le reste de l'application, et
repart de zéro à chaque redémarrage.
