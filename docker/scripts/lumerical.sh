#!/usr/bin/bash

# Prevent multiple sourcing
if [ "${__LUMERICAL_SH_SOURCED:-}" != "" ]; then
    return
fi
readonly __LUMERICAL_SH_SOURCED=1

# Lumerical installer
readonly LUMERICAL_DEB_FILE="/tmp/secrets/lumerical.deb"
# Personal access token
readonly ANSYS_TOKEN_FILE="/tmp/secrets/ansys_token.json"

__lumerical_install_dependencies() {
    # https://ansyshelp.ansys.com/public/account/secured?returnurl=/Views/Secured/corp/v261/en/installation/unix_platform_libraries.html
    # Ubuntu 22.04 LTS
    apt-get install -y --no-install-recommends \
        libasound2t64 \
        libatk-bridge2.0-0t64 \
        libatk1.0-0t64 \
        libatspi2.0-0t64 \
        libavahi-client3 \
        libavahi-common3 \
        libblkid1 \
        libbrotli1 \
        libbsd0 \
        libbz2-1.0 \
        libc6 \
        libcairo-gobject2 \
        libcairo2 \
        libcap2 \
        libcom-err2 \
        libcrypt1 \
        libcups2t64 \
        libdatrie1 \
        libdrm-amdgpu1 \
        libdrm-intel1 \
        libdrm-radeon1 \
        libdrm2 \
        libedit2 \
        libelf1t64 \
        libepoxy0 \
        libexpat1 \
        libffi8 \
        libfontconfig1 \
        libfreetype6 \
        libfribidi0 \
        libgbm1 \
        libgcrypt20 \
        libgdk-pixbuf-2.0-0 \
        libglib2.0-0t64 \
        libglu1-mesa \
        libglvnd0 \
        libglx0 \
        libgmp10 \
        libgnutls30t64 \
        libgpg-error0 \
        libgraphite2-3 \
        libgssapi-krb5-2 \
        libgtk-3-0t64 \
        libharfbuzz0b \
        libhogweed6t64 \
        libice6 \
        libidn2-0 \
        libjpeg-turbo8 \
        libjpeg62 \
        libk5crypto3 \
        libkeyutils1 \
        libkrb5-3 \
        libkrb5support0 \
        libllvm19 \
        libltdl7 \
        liblz4-1 \
        liblzma5 \
        libmd0 \
        libmount1 \
        libnettle8t64 \
        libnsl2 \
        libnspr4 \
        libnss3 \
        libnuma1 \
        libopengl0 \
        libp11-kit0 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpangoft2-1.0-0 \
        libpci3 \
        libpciaccess0 \
        libpcre2-8-0 \
        libpixman-1-0 \
        libselinux1 \
        libsensors5 \
        libsm6 \
        libsystemd0 \
        libtasn1-6 \
        libthai0 \
        libtinfo6 \
        libudev1 \
        libunistring5 \
        libuuid1 \
        libwayland-client0 \
        libwayland-cursor0 \
        libwayland-egl1 \
        libwayland-server0 \
        libx11-6 \
        libx11-xcb1 \
        libxau6 \
        libxcb-dri2-0 \
        libxcb-dri3-0 \
        libxcb-glx0 \
        libxcb-icccm4 \
        libxcb-image0 \
        libxcb-keysyms1 \
        libxcb-present0 \
        libxcb-randr0 \
        libxcb-render-util0 \
        libxcb-render0 \
        libxcb-shape0 \
        libxcb-shm0 \
        libxcb-sync1 \
        libxcb-util1 \
        libxcb-xfixes0 \
        libxcb-xinerama0 \
        libxcb-xkb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxdmcp6 \
        libxext6 \
        libxfixes3 \
        libxft2 \
        libxi6 \
        libxinerama1 \
        libxkbcommon-x11-0 \
        libxkbcommon0 \
        libxrandr2 \
        libxrender1 \
        libxshmfence1 \
        libxslt1.1 \
        libxtst6 \
        libxxf86vm1 \
        libzstd1 \
        xfonts-100dpi \
        xfonts-75dpi \
        libglut3.12 \
        net-tools \
        lsb-release

    # Ansys requires libglut.s0.3 but oon ubunut 24.04 it has been renamed to libglut.so.3.x.y
    ln -sf /usr/lib/x86_64-linux-gnu/libglut.so.3.*.* /usr/lib/x86_64-linux-gnu/libglut.so.3 && ldconfig
}

__lumerical_install_deb() {
    dpkg -i "$LUMERICAL_DEB_FILE"
}

__lumerical_install() {
    if [ -f "$LUMERICAL_DEB_FILE" ]; then
        __lumerical_install_dependencies
        __lumerical_install_deb
    fi
}

__lumerical_license_web() {
    # Enable WEB licensing
    env -u DISPLAY -u WAYLAND_DISPLAY ELECTRON_RUN_AS_NODE=1 \
        /opt/lumerical/*/licensingclient/linx64/LicensingSettings \
        web products enable --mode installation

    # Login using personal access token
    env -u DISPLAY -u WAYLAND_DISPLAY ELECTRON_RUN_AS_NODE=1 \
        /opt/lumerical/*/licensingclient/linx64/LicensingSettings \
        account login --input "$ANSYS_TOKEN_FILE"
}

__lumerical_license() {
    if [ -f "$ANSYS_TOKEN_FILE" ]; then
        __lumerical_license_web
    fi
}

__lumerical_main() {
    __lumerical_install
    __lumerical_license
}

__lumerical_main
