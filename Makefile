# Aliases
development: dev
staging: pre
production: pro

# Set of commands
dev: stop destroy start-consul build start
pre: stop destroy build start
pro: stop destroy build start

# Commands
build:
	docker-compose build
clean:
	docker rm -v $(shell docker ps -a -q -f status=exited) || echo "[INFO] - No exited docker containers to delete..."
	docker rmi $(shell docker images -f "dangling=true" -q) || echo "[INFO] - No dangling docker images to delete..."
	docker volume rm $(shell docker volume ls -qf "dangling=true") || echo "[INFO] - No dangling docker volume to delete..."
destroy:
	docker-compose rm -fv
logs:
	docker-compose logs -f
import-maps:
	docker exec -t nominatim bash /tmp/init.sh
	docker exec -t nominatim bash /app/nominatim/import_nominatim.sh
update:
	rm -rf nominatim-docker
	@git clone --branch=nominatim-2.4 https://github.com/helvalius/nominatim-docker.git
restart:
	docker-compose restart
start:
	docker-compose up -d
start-consul:
	make -C consul build
	make -C consul start
	make -C consul import-consul-keys
stop:
	docker-compose stop
stop-consul:
	make -C consul stop
	make -C consul destroy

