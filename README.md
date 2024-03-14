# Kafka and Zookeeper Setup Using Docker

This guide provides instructions on how to set up Kafka and Zookeeper using Docker, facilitating communication between them through a custom Docker network. This setup is intended for development environments.

## Prerequisites

- Docker installed on your machine. If you do not have Docker installed, follow the [official Docker installation guide](https://docs.docker.com/get-docker/).

## Step 1: Create a Docker Network

Start by creating a custom Docker network named `kafka-network`. This network allows containers to communicate with each other using their container names as hostnames.

```bash
docker network create kafka-network
```

## Step 2: Run Zookeeper

Run the Zookeeper container and attach it to the `kafka-network`. Set the `ALLOW_ANONYMOUS_LOGIN` environment variable to `yes` to allow unauthenticated connections.

```bash
docker run --name zookeeper \
  --network kafka-network \
  -e ALLOW_ANONYMOUS_LOGIN=yes \
  -p 2181:2181 \
  bitnami/zookeeper:latest
```

## Step 3: Run Kafka

Next, run the Kafka container on the `kafka-network`. Configure Kafka to connect to Zookeeper using the Zookeeper container's name (`zookeeper`) as the hostname. This setup enables Kafka to find and connect to Zookeeper within the custom Docker network.

```bash
docker run --name kafka \
  --network kafka-network \
  -p 9092:9092 \
  -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://127.0.0.1:9092 \
  -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT \
  -e KAFKA_CFG_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
  bitnami/kafka
```

This application subscribes to `myTopic` and prints out any messages it receives.

---
### Step 1: Simulate Kafka Messages

Before running your consumer, you need to produce some messages to `myTopic`. You can use Kafka's built-in command-line tools from within the Kafka Docker container:

1. **Access the Kafka Container**:

   ```bash
   docker exec -it kafka /bin/bash
   ```

2. **Create `myTopic`**:

   ```bash
   kafka-topics.sh --create --topic myTopic --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1
   ```

3. **Produce Messages to `myTopic`**:

   Use the Kafka console producer to send some messages:

   ```bash
   kafka-console-producer.sh --topic myTopic --bootstrap-server localhost:9092
   ```

   After entering this command, type messages into the console, and press enter to send each one.

## Step 2: Run Your Go Consumer Application

Return to your Go project directory in a new terminal window and run:

```bash
go run main.go
```

Your application should start and print out the messages you produced to `myTopic`.

This setup gives you a basic local development environment for working with Kafka in Go. As you progress, you might explore more complex topics, such as handling partitions, offsets, and integrating with other systems.

---

## Verifying the Setup

After starting both containers, ensure they are communicating correctly by checking the Kafka container logs for any connectivity errors.

```bash
docker logs kafka
```

If there are no errors related to Zookeeper connectivity, your Kafka and Zookeeper setup is ready for development use.

## Connecting to Kafka from Your Application

With Kafka running and accessible on `localhost:9092`, you can now connect to it from your application. Ensure your Kafka client configuration in your application points to `localhost:9092` for the bootstrap server.

## Stopping and Cleaning Up

To stop and remove the containers, use the following commands:

```bash
docker stop kafka zookeeper
docker rm kafka zookeeper
```

To remove the custom network:

```bash
docker network rm kafka-network
```

## Conclusion

You now have Kafka and Zookeeper running in Docker containers, configured for development. This setup allows you to develop and test applications that produce or consume Kafka messages.
```
