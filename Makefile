.DEFAULT_GOAL = help

CONTANER_NAME=uca-resa-app
DOCKER_COMPOSE=@docker-compose
DOCKER_COMPOSE_EXEC=@docker exec -it
COMPOSER=$(DOCKER_COMPOSE_EXEC) $(CONTANER_NAME) composer
DOCKER_COMPOSE_FILE=docker/docker-compose-dev.yml
DOCKER_COMPOSE_PROD_FILE=docker/docker-compose-prod.yml

## —— Docker 🐳  ———————————————————————————————————————————————————————————————
start:	## Lancer les containers docker (en mode dev)
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d
.PHONY: start

stop:	## Arréter les containers docker
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop
.PHONY: stop

rm:	stop ## Supprimer les containers docker
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) rm -f
.PHONY: rm

restart: rm start	## redémarrer les containers (en mode dev)
.PHONY: restart

bash:	## Connexion au container
	$(DOCKER_COMPOSE_EXEC) $(CONTANER_NAME) bash
.PHONY: bash

ps: ## Affiche les containers docker
	@docker ps
.PHONY: ps

prod:	## Builde et lance les containers docker (en mode prod)
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_PROD_FILE) up -d --build --force-recreate
.PHONY: prod

## —— Composer 🎵 ——————————————————————————————————————————————————————————————
vendor-install:	## Installation des vendors
	$(COMPOSER) install
.PHONY: vendor-install

vendor-update:	## Mise à jour des vendors
	$(COMPOSER) update
.PHONY: vendor-update

clean-vendor: ## Suppression du répertoire vendor puis un réinstall
	$(DOCKER_COMPOSE_EXEC) $(CONTANER_NAME) rm -Rf vendor
	$(DOCKER_COMPOSE_EXEC) $(CONTANER_NAME) rm composer.lock
	$(COMPOSER) install
.PHONY: clean-vendor

## —— Autres 🛠️️ ———————————————————————————————————————————————————————————————
help: ## Liste des commandes
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

tag: ## Met à jour le tag dans le docker-compose (pour mise à jour en prod)
	@sed -i "s/image: app:.*/image: app:`date +%s`/g" docker/docker-compose-prod.yml
.PHONY: tag