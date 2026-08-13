#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake         \
    fmt           \
    libdecor      \
    libzip        \
    ninja         \
    nlohmann-json \
    sdl2          \
    spdlog        \
    tinyxml2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making stable build of G-Diffuser..."
echo "---------------------------------------------------------------"
REPO="https://github.com/Zorkats/G-Diffuser.git"
VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//')"
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./G-Diffuser
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./G-Diffuser
cmake . \
    -Bbuild \
    -GNinja \
    -DNON_PORTABLE=On \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
cmake --build build --config Release
cmake --build build --config Release --target GeneratePortO2R

mv -v build/assets ../AppDir/bin
mv -v build/Ghostship ../AppDir/bin
mv -v build/config.yml ../AppDir/bin
mv -v build/ghostship.o2r ../AppDir/bin
mv -v libultraship/libtcc.so ../AppDir/bin
wget -O ../AppDir/bin/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt
cp -v logo.png ../AppDir/.DirIcon
mv -v logo.png ../AppDir/ghostship.png

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
