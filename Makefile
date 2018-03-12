.SILENT :
.PHONY : deploy undeploy with-all with-tig

# Compose files
COMPOSE_FILES?=-f docker-compose.yml

# Include common Make tasks
root_dir:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
makefiles:=$(root_dir)/makefiles
include $(makefiles)/help.Makefile
include $(makefiles)/compose.Makefile

with-all: with-tig

## Using TIG stack (Warning: put this task before other tasks)
with-tig:
	echo "Using TIG stack..."
	$(eval COMPOSE_FILES += -f docker-compose.tig.yml)

## Deploy containers to Docker host
deploy:
	echo "Deploying infrastructure..."
	-cat .env
	docker-compose $(COMPOSE_FILES) up -d
	echo "Congrats! Infrastructure deployed."

## Un-deploy API from Docker host
undeploy: with-all
	echo "Un-deploying infrastructure..."
	docker-compose $(COMPOSE_FILES) -f docker-compose.config.yml down
	$(eval CONPOSE_FILES = -f docker-compose.yml)
	echo "Infrastructure un-deployed."
