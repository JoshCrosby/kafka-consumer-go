# Use a glibc-based image for the build stage
FROM --platform=linux/amd64 golang:1.18 as builder
LABEL authors="Josh Crosby"

# Install build dependencies (e.g., C compiler and librdkafka)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    librdkafka-dev \
    pkg-config

WORKDIR /app

# Copy go.mod and go.sum and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the application
RUN go build -v -o kafka-consumer-go ./cmd/kafka-consumer-go

# Use Alpine for the final image
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/kafka-consumer-go .

# Command to run the executable
CMD ["./kafka-consumer-go"]
