#!/usr/bin/env bash

readonly DOCKER_IMAGE_NAME="photonix:latest"
readonly DOCKER_ENTRY_POINT="/bin/bash"
readonly DOCKER_WORKSPACE="$(pwd)/workspace"

docker_launcher_linux() {
    local -r host_uid=$(id -u)
    local -r host_gid=$(id -g)
    local -r host_user=$(id -un)
    local -r host_group=$(id -gn)

    local -a user_flags=(
        #--user="${host_uid}:${host_gid}"
    )

    local -a gpu_flags=(
        --device=/dev/kfd
        --device=/dev/dri
        --group-add video
    )

    local -a display_flags=()

    if [[ -n "${DISPLAY}" && -n "${XAUTHORITY}" ]]; then
        local -a x11_flags=(
            -e "DISPLAY=${DISPLAY}"
            -e "XAUTHORITY=/tmp/.Xauthority"
            -v "/tmp/.X11-unix:/tmp/.X11-unix"
            -v "${XAUTHORITY}:/tmp/.Xauthority:ro"
        )
        display_flags+=("${x11_flags[@]}")
    fi

    if [[ -n "${WAYLAND_DISPLAY}" && -n "${XDG_RUNTIME_DIR}" ]]; then
        local -a wayland_flags=(
            -e "WAYLAND_DISPLAY=${WAYLAND_DISPLAY}"
            -e "XDG_RUNTIME_DIR=/tmp"
            -v "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}:/tmp/${WAYLAND_DISPLAY}"
        )
        display_flags+=("${wayland_flags[@]}")
    fi
    
    mkdir -p "${DOCKER_WORKSPACE}"

    # Run container
    docker run -it \
        "${user_flags[@]}" \
        "${display_flags[@]}" \
        "${gpu_flags[@]}" \
        -v "${DOCKER_WORKSPACE}:/workspace" \
        "${DOCKER_IMAGE_NAME}" 
}

docker_launcher_linux

