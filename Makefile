include ./srcs/.env
export

DATA_DIR=/home/bposa/data
MARIADB_DIR=$(DATA_DIR)/mariadb
WORDPRESS_DIR=$(DATA_DIR)/wordpress
CERT_DIR=./secrets

CERT_FILE=$(CERT_DIR)/public_certificate.crt
KEY_FILE=$(CERT_DIR)/private.key

COMPOSE_FILE=srcs/docker-compose.yml



all: certif $(DATA_DIR) $(MARIADB_DIR) $(WORDPRESS_DIR)
	@$(MAKE) img
	@$(MAKE) up

clean:
	@echo "Removing containers, images, volumes.."
	@docker compose -f $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans

fclean: clean
	@echo "Disk usage before fclean:"
	- docker system df

	- docker compose -f $(COMPOSE_FILE) stop
	- docker rm -f $(docker ps -aq) 2>/dev/null
	- docker rmi -f $(docker images -aq) 2>/dev/null
	- docker volume rm $(docker volume ls -q) 2>/dev/null
	- docker network rm $(docker network ls -q) 2>/dev/null

	- docker builder prune -af
	- docker system prune -af --volumes

	- sudo rm -rf $(DATA_DIR)

	@echo "Cleanup done. Disk usage:"
	- docker system df

re: fclean all



$(DATA_DIR):
	@mkdir -p $@

$(MARIADB_DIR):
	@mkdir -p $@

$(WORDPRESS_DIR):
	@mkdir -p $@

img:
	@docker compose -f $(COMPOSE_FILE) build

up:
	@docker compose -f $(COMPOSE_FILE) up -d

down:
	@docker compose -f $(COMPOSE_FILE) down

certif:
	@test -d $(CERT_DIR) || (echo "ERROR: Folder $(CERT_DIR) missing!" && exit 1)
	openssl req -x509 -nodes \
		-out $(CERT_FILE) \
		-keyout $(KEY_FILE) \
		-subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=$(DOMAIN_NAME)" 2>/dev/null

.PHONY: all clean fclean re up down img certif
