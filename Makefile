# Makefile for managing Docker containers for kafka-consumer-go, Kafka, and Zookeeper

.PHONY: build up down clean ps logs kafka-consumer-go

# Build the Docker images for all services defined in docker-compose.yml
build:
	@echo "Building Docker images for all services..."
	docker-compose build

# Start all services in background (detached mode)
up:
	@echo "Starting all services (Zookeeper, Kafka, kafka-consumer-go)..."
	docker-compose up -d

# Stop and remove containers, networks created by 'up'
down:
	@echo "Stopping all services and cleaning up..."
	docker-compose down

# Remove all unused containers, networks, volumes, and images
clean:
	@echo "Removing unused Docker resources..."
	docker system prune -af
	docker volume prune -f

# List all running containers
ps:
	@echo "Listing all running containers..."
	docker-compose ps

# Follow log output for all services
logs:
	@echo "Tailing logs for all services..."
	docker-compose logs -f

# Rebuild and restart the kafka-consumer-go service
kafka-consumer-go:
	@echo "Rebuilding and restarting the kafka-consumer-go service..."
	docker-compose up -d --no-deps --build kafka-consumer-go
