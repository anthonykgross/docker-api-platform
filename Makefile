
FIG=docker-compose
RUN_WEB=$(FIG) run --rm web
EXEC_WEB=$(FIG) exec web
CONSOLE=gosu docker bin/console

.DEFAULT_GOAL := help
.PHONY: help build install start stop boot debug debug-root db db-migrate test

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##
## Project setup
##---------------------------------------------------------------------------

build:          ## Build the Docker image
build:
	$(FIG) build

install:        ## Install vendors
install:
	$(RUN_WEB) install

start:          ## Install the full project (build install db db-migrate up)
start: build install up

stop:           ## Stop containers
stop:
	$(FIG) kill
	$(FIG) rm -v --force

up:             ## Run images
up:
	docker-compose up -d

##
## Database
##---------------------------------------------------------------------------


db:             ## Reset the database
db:
	$(RUN_WEB) $(CONSOLE) doctrine:database:drop --force --if-exists
	$(RUN_WEB) $(CONSOLE) doctrine:database:create --if-not-exists

db-migrate:     ## Update the database
db-migrate:
	$(RUN_WEB) $(CONSOLE) doctrine:schema:update --force

##
## Tests
##---------------------------------------------------------------------------

debug:          ## Debug container
debug:
	$(EXEC_WEB) gosu docker bash

debug-root:     ## Debug container as Root user
debug-root:
	$(EXEC_WEB) bash

test:           ## Run tests
test:
	$(EXEC_WEB) /entrypoint.sh tests

##