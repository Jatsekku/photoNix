#!/usr/bin/env bash

readonly DOCKER_LAUNCHER_DIR="$(dirname "${BASH_SOURCE[0]}")"
readonly PHOTONIX_ROOT_DIR="$(realpath "${DOCKER_LAUNCHER_DIR}/..")"
readonly DOCKER_COMPOSE_BASE="${PHOTONIX_ROOT_DIR}/docker/docker-compose.yaml"
readonly DOCKER_COMPOSE_NVIDIA="${PHOTONIX_ROOT_DIR}/docker/docker-compose.nvidia.yaml"

# Workspace
HOST_WORKSPACE_DIR="${HOST_WORKSPACE_DIR:-$(pwd)}"
if [ "${HOST_WORKSPACE_DIR}" = "${PHOTONIX_ROOT_DIR}" ]; then
    HOST_WORKSPACE_DIR="${PHOTONIX_ROOT_DIR}/workspace"
fi
export HOST_WORKSPACE_DIR
echo "Workspace directory: $HOST_WORKSPACE_DIR" 

# Secrets 
HOST_SECRETS_DIR="${HOST_SECRETS_DIR:-${PHOTONIX_ROOT_DIR}/secrets}"
export HOST_SECRETS_DIR
echo "Secrets directory: $HOST_SECRETS_DIR"

# Libraries
HOST_LIBRARIES_DIR="${PHOTONIX_ROOT_DIR}/libraries"
export HOST_LIBRARIES_DIR
echo "Libraries directory: $HOST_LIBRARIES_DIR"

__has_nvidia_gpu() {
    if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
        return 0 # nVidia GPU detected
    fi
    return 1 # no nVidia GPU
}

docker_launcher_linux() {
    local compose_args=("-f" "$DOCKER_COMPOSE_BASE")

    if __has_nvidia_gpu; then
        echo "nVidia GPU detected"
        compose_args+=("-f" "$DOCKER_COMPOSE_NVIDIA")
    fi

    docker compose "${compose_args[@]}" up -d --build
    docker compose "${compose_args[@]}" exec photonix /bin/bash
}

docker_launcher_linux
