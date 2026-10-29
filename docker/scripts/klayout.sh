#!/usr/bin/bash

# Prevent multiple sourcing
if [ -n "${__KLAOUT_SH_SOURCED:-}" ]; then
    return
fi
readonly __KLAYOUT_SH_SOURCED=1

KLAYOUT_HOME="${KLAYOUT_HOME:-/.klayout}"

__klayout_install() {
    apt-get install -y --no-install-recommends \
        klayout \
        git
}

__klayout_clone_plugin() {
    local -r plugin_name="$1"
    local -r plugin_url="$2"
    local -r retries="${3:-5}"
    local -r delay="${4:-3}"

    local -r salt_dir="${KLAYOUT_HOME}/salt"
    local -r target_dir="${salt_dir}/${plugin_name}"

    mkdir -p "${salt_dir}"

    local attempt
    for ((attempt = 1; attempt <= retries; attempt++)); do 
        if [[ -d "${target_dir}" ]]; then
            # Git pull if repo exist
            if git -C "${target_dir}" pull; then
                return 0
            fi
        else
            # Git clone otherwise
            if git clone "${plugin_url}" "${target_dir}"; then
                return 0
            fi
        fi

        echo "WARNING: Attempt ${attempt}/${retries} failed for ${plugin_name}. Retrying in ${delay}s..."

        rm -rf "${target_dir}" 2>/dev/null || true

        if ((attempt < retries)); then
            sleep "${delay}"
        fi
    done

    echo "ERROR: Failed to clone/update '${plugin_name}' from ${plugin_url} after ${retries} attempts."
    return 1
}

__klayout_install_plugins() {
    # klive | requires: { }
    __klayout_clone_plugin "klive" "https://github.com/gdsfactory/klive.git" 3 1

    # xsection | requires: { }
    __klayout_clone_plugin "xsection" "https://codeberg.org/klayoutmatthias/xsection.git" 3 1

    # siepic_tools | requires: { "xsection" "python3-numpy" "python3-packaging" }
    __klayout_clone_plugin "siepic_tools" "https://github.com/SiEPIC/SiEPIC-Tools.git" 3 1
    apt-get install -y --no-install-recommends python3-numpy python3-packaging

    # siepic_ebeam_pdk | requires: { "xsection" "siepic_tools" }
    __klayout_clone_plugin "siepic_ebeam_pdk" "https://github.com/SiEPIC/SiEPIC_EBeam_PDK.git" 3 1
}

__klayout_grant_permissions() {
    chmod -R 777 "${KLAYOUT_HOME}" 2>/dev/null || true
}

klayout_main() {
    __klayout_install
    __klayout_grant_permissions
    __klayout_install_plugins
}

klayout_main

