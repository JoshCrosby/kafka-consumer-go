# Use the official Go image as a parent image
FROM golang:1.18 as builder
LABEL authors="Josh Crosby"

# Set the working directory inside the container
WORKDIR /app

# Copy the local package files to the container's workspace
COPY . .

# Build the Go app for a small image
RUN CGO_ENABLED=0 GOOS=linux go build -v -o kafka-consumer-go ./cmd/kafka-consumer-go

# Use a small base image
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/kafka-consumer-go .

# Command to run the executable
CMD ["./kafka-consumer-go"]
