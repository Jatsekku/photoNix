#!/usr/bin/env bash

readonly DOCKER_LAUNCHER_DIR="$(dirname "${BASH_SOURCE[0]}")"
readonly PHOTONIX_ROOT_DIR="$(realpath "${DOCKER_LAUNCHER_DIR}/..")"
readonly DOCKER_COMPOSE_FILE="${PHOTONIX_ROOT_DIR}/docker/docker-compose.yaml"

# Workspace
HOST_WORKSPACE_DIR="${HOST_WORKSPACE_DIR:-$(pwd)}"
export HOST_WORKSPACE_DIR
echo "Workspace directory: $HOST_WORKSPACE_DIR" 

# Secrets 
HOST_SECRETS_DIR="${HOST_SECRETS_DIR:-${PHOTONIX_ROOT_DIR}/secrets}"
export HOST_SECRETS_DIR
echo "Secrets directory: $HOST_SECRETS_DIR" 

docker_launcher_linux() {
    docker compose -f "$DOCKER_COMPOSE_FILE" up -d --build
    docker compose -f "$DOCKER_COMPOSE_FILE" exec photonix /bin/bash
}

docker_launcher_linux
