#!/usr/bin/bash

# Prevent multiple sourcing
if [ -n "${__KLAOUT_SH_SOURCED:-}" ]; then
    return
fi
readonly __KLAYOUT_SH_SOURCED=1

__klayout_install() {
    apt-get install -y --no-install-recommends \
        klayout
}

__klayout_install_plugin() {
    local -r plugin="$1"
    local -r retries="${2:-5}"
    local -r delay="${3:-3}"

    local attempt_cnt=0

    for ((attempt = 1; aattempt <= retries; attempt++)); do 
        if klayout -y "${plugin}"; then
            return 0
        fi

        if ((attempt < retries)); then
            sleep "${delay}"
        fi
    done

    echo "ERROR: Failed to install "${plugin}" after "${retries}" attempts."
    return 1
}

__klayout_setup() {
    __klayout_install_plugin "klive" 5 3
    __klayout_install_plugin "siepic_tools" 5 3
    __klayout_install_plugin "siepic_ebeam_pdk" 5 3
}

klayout_main() {
    local -r command="$1"

    case "$command" in
        install)
            __klayout_install
            ;;
        setup)
            __klayout_setup
            ;;
        *)
            return 1
            ;;
        esac
}

klayout_main "$1"

