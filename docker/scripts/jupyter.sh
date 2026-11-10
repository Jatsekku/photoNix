#!/usr/bin/bash

# Prevent multiple sourcing
if [ -n "${__JUPYTER_SH_SOURCED:-}" ]; then
    return
fi
readonly __JUPYTER_SH_SOURCED=1

JUPYTER_HOME="${JUPYTER_HOME:-${HOME}/.jupyter}"

__jupyter_install() {
    uv tool install jupyterlab --with pip
}

__jupyter_configure() {
    mkdir -p "${JUPYTER_HOME}"
    local -r config_file="${JUPYTER_HOME}/jupyter_server_config.py"

    # shellcheck disable=SC2129
    echo "c.ServerApp.ip = '0.0.0.0'" >> "${config_file}"
    echo "c.ServerApp.port = 8888" >> "${config_file}"
    echo "c.ServerApp.open_browser = False" >> "${config_file}"
    echo "c.ServerApp.allow_root = True" >> "${config_file}"
}

jupyter_main() {
    __jupyter_install
    __jupyter_configure
}

jupyter_main
