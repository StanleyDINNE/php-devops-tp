

#import "Typst/Template_default.typ": set_config
#import "Typst/Constants.typ": document_data, line_separator, figures_folder
#import "Typst/Util.typ": file_folder, import_csv_filter_categories, insert_code-snippet, insert_figure as i_f, to_string, todo, transpose


#show: document => set_config(
	title: [Documentation du pipeline CI/CD dans\ _CircleCI_ pour une #link("https://github.com/StanleyDINNE/php-devops-tp")[Application Web PHP]],
	title_prefix: none,
	authors: (document_data.author.reb, document_data.author.stan, document_data.author.raf).join("\n"),
	context: "Security & Privacy 3.0",
	date: datetime.today().display(),
	image_banner: align(center, image("Typst/logo_Polytech_Nice_X_UCA.png", width: 60%)),
	header_logo: align(center, image("Typst/logo_Polytech_Nice_X_UCA.png", width: 40%)),
)[#document]

#let insert_figure(title, width: 100%, border: true) = {
	i_f(title, folder: "../" + figures_folder + "/Documentation", width: width, border: border)
}


#outline(title: "Sommaire", indent: 1em, depth: 3) <table_of_contents>
#pagebreak()



Tips : pour l'édition du fichier de configuration #file_folder(".circleci/config.yml"), utiliser des extensions (comme par exemple #link("https://open-vsx.org/extension/redhat/vscode-yaml")[_redhat.vscode-yaml_]) qui vont garantir l'intégrité de la syntaxe _YAML_, et ansi éviter une configuration cassée et un rejet par _CircleCI_ comme sur la capture ci-dessous.

#insert_figure("Fichier de configuration YAML syntaxiquement invalide, non lisible par CircleCI", width: 50%)

= Configuration de base du pipeline dans #file_folder(".circleci/config.yml")

Le fichier #file_folder(".circleci/config.yml") est présent à la racine du projet, configuration standard pour que _CircleCI_ le voit.

+ Création d'un compte _CircleCI_ avec GitHub, de manière à pouvoir lier directement le dépôt à CircleCI
+ Définition d'un workflow `main_workflow` avec des jobs de base :
	+ `debug-info` : qui sert à afficher des variables d'environnement, le contexte d'exécution, etc.
	+ `build-setup` : job parent à tous les jobs de tests, metrics, lint, security checks, etc.
	+ `test-phpunit` : job de test pour assurer que le code est toujours test-compliant

Il faut ensuite définir une politque de contribution, à l'aide de pull-requests, contribution dans des branches comme `develop*` premièrement, puis intégration du code de releases dans des branches `release/*`, et quand on veut

Ainsi, à partir de ça, on peut définir les filtres de branches ou tag qui vont déclencher la construction d'une image docker du projet, et le déploiement sur les serveurs.

= Configuration de _CircleCI_

== Dans les Paramètres du projet > Variables d'environnement

#insert_figure("Configuration des variables d'environnement", width: 70%)

== Dans les Paramètres du projet > Clefs SSH

#insert_figure("Ajout des clefs SSH des utilisateurs updater_agent sur les serveurs de staging et prodution", width: 70%)

== Dans les Paramètres d'organisation > Contextes

#insert_figure("Définition des tokens dans les Contextes", width: 70%)

Injection du contexte dans un job avec la directive `context`.

À noter que tous les tokens sauf celui d'Infisical peuvent être déplacés dans Infisical, et injectés en ligne de commande dans le pipeline avec la CLI d'Infisical.


= Ajout de jobs de metrics et lint

Ajouter de tels jobs pour avoir une meilleure visibilité sur le code, notamment au travers des rapports, trouvable dans la section _Artifacts_ de chaque job.

= Ajout du jobs de containerisation

Le job qui construit l'image suit les étapes suivantes :
+ Reconstruction du nom du projet avec les variables d'environnement
+ Construction du tag avec le nom de branche et la date, ou le tag git
+ Connexion au stockage d'artifacts _GitHub Container Registry_
	- Utilisation des credentials stockés dans le contexte CircleCI des tokens
+ Construction de l'image docker à partir du code source du dépôt GitHub récupéré et injection des variables d'environnement adéquates
+ Tag de l'image
+ Stockage de l'image sur _GHCR_


= Ajout des jobs de déploiement

== Serveur staging

Avec le serveur configuré.

Connexion ssh avec injection de l'ensemble des commandes ci-dessous

+ Actualisation "sans-échec"/"multirisque" du dépôt en local
	- Changements locaux ignorés
	- Modifications divergentes ignorées en local : priorité au remote/orign
+ Mise à jour des dépendances avec `composer`
+ Overwrite du contenu du dossier du service #file_folder("/var/www/html")
+ Rechargement de FPM-PHP

== Server production

Connexion ssh avec injection de l'ensemble des commandes ci-dessous

+ Reconstruction du nom de l'image
+ Arrêt de suppression du container en cours d'exécution
+ Récupération de l'image distante en denière version
+ Instanciation du container


=  Si AWS tombe
+ On a restart et reconfiguré les machines
+ Récupération des addresses IPv4 publiques
+ Aller dans CircleCI > Projects > php-devops-tp > Project settings > SSH keys
	- Redéfinir (réutiliser) les clefs privées des deux serveurs, en remplaçant les hostnames par les IP copiées
+ Aller dans CircleCI > Projects > php-devops-tp > Project settings > Environment Variables
	- Mettre à jour de la même façon les IP pour les clefs `STAGING_SSH_HOST` et `PRODUCTION_SSH_HOST`
