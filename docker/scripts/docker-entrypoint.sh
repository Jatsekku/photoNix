#!/usr/bin/bash

# Prevent multiple sourcing
if [ -n "${__DOCKER_ENTRYPOINT_SH_SOURCED:-}" ]; then
    return
fi
readonly __DOCKER_ENTRYPOINT_SH_SOURCED=1

source "/scripts/klayout.sh"

__de_klayout_setup() {
    if [[ ! -d "${KLAYOUT_HOME}" ]]; then
        __klayout_setup
    else
        echo "${KLAYOUT_HOME} exist"
    fi 
}

de_main() {
    __de_klayout_setup
    exec bash
}

de_main
