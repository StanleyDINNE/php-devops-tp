

= Documentation CI-CD

- Si AWS tombe
	+ On a restart et reconfiguré les machines
	+ Récupération des addresses IPv4 publiques
	+ Aller dans CircleCI > Projects > php-devops-tp > Project settings > SSH keys
		- Redéfinir (réutiliser) les clefs privées des deux serveurs, en remplaçant les hostnames par les IP copiées
	+ Aller dans CircleCI > Projects > php-devops-tp > Project settings > Environment Variables
		- Mettre à jour de la même façon les IP pour les clefs `STAGING_SSH_HOST` et `PRODUCTION_SSH_HOST`
