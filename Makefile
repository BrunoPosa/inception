DATA_DIR=/home/bposa/data
MARIADB_DIR=$(DATA_DIR)/mariadb
WORDPRESS_DIR=$(DATA_DIR)/wordpress

COMPOSE_FILE=srcs/compose.yaml

all: $(MARIADB_DIR) $(WORDPRESS_DIR)
	@$(MAKE) images
	@$(MAKE) up

$(MARIADB_DIR):
	@echo "Creating MariaDB data directory..."
	@mkdir -p $@

$(WORDPRESS_DIR):
	@echo "Creating WordPress data directory..."
	@mkdir -p $@

images:
	@docker compose -f $(COMPOSE_FILE) build

up:
	@docker compose -f $(COMPOSE_FILE) up -d

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:
	@echo "Removing containers, images, volumes.."
	@docker compose -f $(COMPOSE_FILE) down --rmi all -v

fclean: clean
	@echo "Removing data directories.."
	sudo rm -rf $(DATA_DIR)	
	docker system prune -af --volumes || true
	docker rm -f $$(docker ps -aq) || true
	docker rmi -f $$(docker images -aq) || true
	docker volume rm $$(docker volume ls -q) || true
	docker network prune -f || true
	docker builder prune -af || true

re: fclean all

.PHONY: all clean fclean re up down images
