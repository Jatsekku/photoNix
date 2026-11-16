#!/usr/bin/bash

# Prevent multiple sourcing
if [ -n "${__TIDY3D_SH_SOURCED:-}" ]; then
    return
fi
readonly __TIDY3D_SH_SOURCED=1

readonly TIDY3D_CONFIG_DIR="${HOME}/.config/tidy3d"
readonly TIDY3D_CONFIG_FILE="/tmp/secrets/tidy3d_config.toml"

__tidy3d_copy_config() {
    if [ -f "${TIDY3D_CONFIG_FILE}" ]; then
        mkdir -p "${TIDY3D_CONFIG_DIR}"
        cp "${TIDY3D_CONFIG_FILE}" "${TIDY3D_CONFIG_DIR}/config.toml"
    fi
}

tidy3_main() {
    __tidy3d_copy_config
}

tidy3_main

