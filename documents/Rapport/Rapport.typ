
// Add the VSCode extension "Typst" to edit this file easily!


#import "Typst/Template_default.typ": set_config
#import "Typst/Constants.typ": document_data
#import "Typst/Util.typ": file_folder, import_csv_filter_categories, insert_code-snippet, insert_figure, to_string, todo, transpose


#show: document => set_config(
	title: [Configuration d'un Pipeline CI/CD\ pour une Application Web PHP],
	title_prefix: "TP: ",
	authors: (document_data.author.reb, document_data.author.stan, document_data.author.raf).join("\n"),
	context: "Security & Privacy 3.0",
	date: datetime.today().display(),
	image_banner: align(center, image("Typst/logo_Polytech_Nice_X_UCA.png", width: 60%)),
	header_logo: align(center, image("Typst/logo_Polytech_Nice_X_UCA.png", width: 40%)),
)[#document]



= Compréhension et configuration de base

== Analyse du projet PHP

Il s'agit d'une application PHP simple, avec principalement #file_folder("index.php"), qui va afficher deux rectangles contenant chacun du texte, et ce en appelant l'app' dédiée #file_folder("ImageCreator.php").

- #file_folder("ImageCreator.php") définit la classe `ImageCreator` qui va prendre en paramètre deux couleurs et deux chaînes de charactères pour ainsi remplir l'objectif énoncé à l'instant.
- L'utilisation du gestionnaire de packages PHP "Composer" est ici nécessaire pour l'appel à la #link("https://carbon.nesbot.com/docs/")[librairie de gestion de date & heure "Carbon"], dont l'unique but est de joindre au texte du premier rectangle, la date et l'heure à laquelle celui-ci est généré et donc en l'occurance à peu près la date et l'heure de l'affichage de la page.
Étant donné le peu d'éléments soulignés, d'autres plus annecdotiques peuvent être évoqués :
- Une page #file_folder("info.php") est présente et génère la page d'information standard de `php` grâce à `phpinfo()`.
- Une police d'écriture présente via la fichier #file_folder("consolas.ttf") est utilisée par `ImageCreator`
Concernant la configuration et le déploiement de l'application, celle-ci est containerisée, avec Docker, via #file_folder("Docker/Dockerfile").


== Configuration de l'environnement Docker

Commençons par construire l'image

#insert_code-snippet(title: [Construction de l'image docker,\ instanciation d'un container et accès au terminal du container],
	```bash
	cd "php-devops-tp"

	# Commandes docker lancées en tant qu'utilisateur root

	# Construction de l'image à partir de la racine du projet
	docker build --tag php-devops-tp --file Docker/Dockerfile .
	# L'image a bien été créée
	docker images

	# Instanciation d'un container qui va tourner en arrière-plan
	docker run --detach --interactive --tty \
		--publish target=80,published=127.0.0.1:9852,protocol=tcp \
		--add-host host.docker.internal:host-gateway \
		--name php-devops-tp_container php-devops-tp
	# Il nous est possible d'accéder à la page via le navigateur, à l'adresse "http://localhost:9852"

	# Le container est lancé
	docker ps

	# Possibilité d'enter dans le container via tty avec `bash`
	docker exec --interactive --tty php-devops-tp_container /bin/bash
	```
)
Nous avons à présent
#insert_figure("Container up & running & accessible", width: 50%)

Un problème apparaît cependant avec #file_folder("index.php") comme le montre l'image ci-dessous
#insert_figure("Problem with index.php")

Pour le corriger, il reste à importer les dépendances avec "Composer" (```bash composer update```), soit manuellement avec le tty interactif une fois le container lancé, soit en ajoutant l'instruction dans le #file_folder("Dockerfile").
#insert_figure("index.php fonctionel après l'ajout des dépendances")
Il sera choisi de modifier le #file_folder("Dockerfile") pour que les dépendances soient déjà correctes lors de l'instanciation d'un container issu de l'image docker.

= Mise en place du pipeline CI/CD

== Configuration GitHub et CircleCi

Le dépôt étant à présent sur GitHub, nous allons configurer CircleCi


== Création du pipeline CI/CD

== Gestion des secrets avec Infisical


= Extension du Pipeline

== Ajout de jobs dévaluation de code

== Intégration de la qualité du code

== Déploiement automatisé sur AWS EC2
