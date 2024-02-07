#!/bin/bash

#########################
# Initial project setup #
#########################

# Add `.zip` content
git add .
git commit --message "Add project structure" --author "Christian DELETTRE <teachings@deltekzen.com>" --date "2023-12-12 09:30:00 +01:00"
# Add fixes
git commit --message "Fix Dockerfile & other other small changes" --author "Christian DELETTRE <teachings@deltekzen.com>" --date "2023-12-13 20:18:00 +01:00"



###################################
# Running docker commands as root #
###################################


# Check images
docker images
# Build the project image
docker build --tag php-devops-tp --file docker/Dockerfile .

# Summon container running in the background
docker run --detach --interactive --tty \
	--publish published=127.0.0.1:9852,target=80,protocol=tcp \
	--add-host host.docker.internal:host-gateway \
	--name php-devops-tp_container php-devops-tp
# Then we can access the page via the webbrowser at "http://localhost:9852"

# Check that the container is up and running
docker ps

# Enter the container via `bash`
docker exec --interactive --tty php-devops-tp_container /bin/bash

# Shut down container
docker kill php-devops-tp_container
# Remove container
docker rm php-devops-tp_container
# Remove the image
docker image rm php-devops-tp
