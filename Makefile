init: docker-down create-networks docker-pull docker-build docker-up success info
clear-init: docker-down-clear create-networks docker-pull docker-build docker-up success info
up: docker-up success info
down: docker-down
restart: down up


docker-up:
	docker compose up -d

docker-down:
	docker compose down --remove-orphans

docker-down-clear:
	docker compose down -v --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build --pull

create-networks:
	@docker network create proxy proxy 2>/dev/null || true
	@docker network create develop proxy 2>/dev/null || true


php:
	docker compose run --rm php-cli bash

node:
	docker compose run --rm node bash

success:
	@echo "\033[32m "
	@echo "Docker Compose Stack successfully started!"

info:
	@echo "STACK URLS:"
	@echo " - App: \t https://dev.app.loc"
	@echo "DEV-TOOLS URLS:"
	@echo " - Traefik: \t https://traefik.app.loc"
	@echo " - Buggregator:  https://buggregator.app.loc"
