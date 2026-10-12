## Description

Accélère l'inscription des utilisateurs et la création des tâches.

Le verrou protège des accès concurrents. Sur le chemin chaud de l'inscription, ce verrou coûte cher. Cette modification le retire des opérations rapides.

L'hypothèse de départ : l'application tourne sur un seul processus.