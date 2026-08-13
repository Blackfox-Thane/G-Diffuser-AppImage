#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cmake \
    ninja         \
    gcc           \
    glew          \
    zlib          \
    bzip2         \
    fmt           \
    libdecor      \
    libzip        \
    nlohmann-json \
    sdl2          \
    spdlog        \
    tinyxml2      \
    python3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

echo "Getting app for G-Diffuser..."
echo "---------------------------------------------------------------"
wget -q https://github.com/Zorkats/G-Diffuser/releases
mkdir -p ./AppDir/bin
tar -xvzf ./G-Diffuser-v1.0.1-linux-x64.tar.gz -C ./AppDir/bin
rm ./G-Diffuser-v1.0.1-linux-x64.tar.gz

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
