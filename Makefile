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
	@docker compose -f $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans

fclean: clean #docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
	@echo "Stopping all containers..."
	- docker compose -f $(COMPOSE_FILE) stop

	@echo "Removing all containers..."
	- docker rm -f $(docker ps -aq) 2>/dev/null

	@echo "Removing all images..."
	- docker rmi -f $(docker images -aq) 2>/dev/null

	@echo "Removing all volumes..."
	- docker volume rm $(docker volume ls -q) 2>/dev/null

	@echo "Removing unused networks..."
	- docker network rm $(docker network ls | awk '/ bridge|host|none /{next} {print $1}') 2>/dev/null

	@echo "Pruning build cache..."
	- docker builder prune -af

	@echo "Final system prune..."
	- docker system prune -af --volumes

	@echo "Removing data directories.."
	- sudo rm -rf $(DATA_DIR)

	@echo "Cleanup done. Current disk usage:"
	- docker system df

re: fclean all

.PHONY: all clean fclean re up down images
