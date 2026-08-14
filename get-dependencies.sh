#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
  bzip2	\
  cmake	\
  fmt \
  gcc	\
  glew \
  libdecor \
  libzip \
  ninja	\
  nlohmann-json	\
  python \
  sdl2 \
  sdl2_net \
  spdlog \
  tinyxml2 \
  zlib

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package zenity-rs-bin

# If the application needs to be manually built that has to be done down here

echo "Getting app for G-Diffuser..."
echo "---------------------------------------------------------------"
REPO="https://github.com/Zorkats/G-Diffuser"
VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//')"
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./G-Diffuser
echo "$VERSION" > ~/version

mkdir -p AppDir/bin
cd G-Diffuser
mkdir -p build/x64-linux

cmake -S . \
  -Bbuild/x64-linux \
  -GNinja \
  -DCMAKE_BUILD_TYPE=Release

cmake --build build/x64-linux --target G-Diffuser

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
