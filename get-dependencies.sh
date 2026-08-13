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

echo "Getting app..."
echo "---------------------------------------------------------------"
case "$ARCH" in # they use X64 and ARM64 for the zip links
	x86_64)  zip_arch=Linux-X64-Release;;
	aarch64) zip_arch=Linux-ARM64-Release;;
esac
TAR_GZ_LINK=$(wget -qO- https://github.com/Zorkats/G-Diffuser/releases \
      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*G-Diffuser.*$zip_arch.tar.gz")
echo "$ZIP_LINK" | awk -F'/' '{gsub(/^v/, "", $(NF-1)); print $(NF-1); exit}' > ~/version
wget --retry-connrefused --tries=30 "$TAR_GZ_LINK" -O /tmp/app.tar.gz

mkdir -p ./AppDir/bin
bsdtar -xvf /tmp/app.tar.gz -C .
bsdtar -xvf ./G-Diffuser-v1.*-linux-x64.tar.gz -C ./AppDir/bin

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
