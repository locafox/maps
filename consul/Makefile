build:
	docker-compose -f docker-compose-dev.yml build
destroy:
	docker-compose -f docker-compose-dev.yml rm -f
logs:
	docker-compose -f docker-compose-dev.yml logs -f
start:
	if [ $$(docker ps | grep -c '0.0.0.0:8500') -eq 0 ]; then \
	    docker-compose -f docker-compose-dev.yml up -d; \
	fi
stop:
	docker-compose -f docker-compose-dev.yml stop

import-consul-keys:
	docker run --rm -t consul_preprocessing-consul bash /tmp/import_keys.sh

