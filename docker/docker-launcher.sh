#!/usr/bin/env bash

readonly DOCKER_LAUNCHER_PATH="$(dirname "${BASH_SOURCE[0]}")"
readonly DOCKER_COMPOSE_PATH="${DOCKER_LAUNCHER_PATH}/docker-compose.yaml"
readonly HOST_WORKSPACE_DIR="$(pwd)"


docker_launcher_linux() {
    export HOST_WORKSPACE_DIR
    docker compose -f "${DOCKER_COMPOSE_PATH}" run --rm --build photonix /bin/bash
}

docker_launcher_linux

