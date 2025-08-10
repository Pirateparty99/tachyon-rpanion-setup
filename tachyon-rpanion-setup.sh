#!/bin/bash

apt update && apt upgrade -y

# QOL tools:
apt install -y tmux netcat net-tools ldnsutils inetutils-traceroute 

# Mavlink Router setup:

apt install -y git meson ninja-build pkg-config gcc g++ systemd libgtest-dev libgmock-dev cmake clang-tidy \
    libxml2-dev libxslt-dev python-dev liblzma5=5.2.4-1ubuntu1.1 libunwind8=1.2.1-9ubuntu0.1 liblzma-dev libunwind-dev
pip3 install --upgrade --root-user-action ignore meson netifaces numpy future lxml gst


# Build and install Mavlink Router:
mkdir git-repos
cd git-repos
git clone https://github.com/mavlink-router/mavlink-router.git
cd mavlink-router
git submodule update --init --recursive

meson setup build .
# ninja -C build
ninja -C build install

# Tachyon MavLink "Rpanion Server" setup:
cd ..
git clone https://github.com/stephendade/Rpanion-server.git

# Copy the modified "index.js" file to fix crashes due to "Uncaught exception: TypeError: res.status is not a function" error:
cp server/index.js Rpanion-server/server/index.js

cd Rpanion-server/deploy
sed -i -e 's/sudo reboot/#sudo reboot/g' -e 's/\bif\b/#if/g' -e 's/\bfi\b/#fi/g' -e 's/echo ""/#echo ""/g' -e 's/ echo "#/#echo "#/g' -e 's/echo "s/#echo "s/g' -e 's/echo "g/#echo "g/g' ./RasPi-ubuntu-deploy.sh
./RasPi-ubuntu-deploy.sh

# Change the NodeJS version to 20.5.1:
npm install -g n
../changenodeversion.sh -y

#npx npm-check-updates -u
# npm audit fix --force

# Install NPM dependencies (first npm install seems to fail):
npm i || true

# Idk enough about NPM packages/NodeJS to understand why the previous install fails 
# and the second install doesn't but this seems to work:

#rm -rf package-lock.json node_modules 
#npm install || true

# Start Rpanion dev server:
# npm run dev

# Create Debian package for Rpanion Server:
pwd
sed -ie 's/${DEB_HOST_ARCH}/arm64/g' ../package.json

# Change dependencies to Ubuntu 20 dependencies:
sed -ie 's/"dependencies":\s*"[^"]*"/"dependencies": "nodejs  (>= 20.19.4-1nodesource1), gstreamer1.0-plugins-good (>= 1.16.2-3), libgstrtspserver-1.0-dev (>= 1.16.2-3), gstreamer1.0-plugins-base-apps (>= 1.16.2-3), gstreamer1.0-plugins-ugly (>= 1.16.2-2build1), gstreamer1.0-plugins-bad (>= 1.16.2-3), network-manager (>= 1.22.10-1ubuntu2.4particle1), python3 (>= 3.8.2-0ubuntu2), python3-dev (>= 3.8.2-0ubuntu2), python3-gst-1.0 (>= 1.16.2-2), python3-pip (>= 20.0.2-5ubuntu1.11), dnsmasq (>= 2.90-0ubuntu0.20.04.1), libxslt1-dev (>= 1.1.34-4ubuntu0.20.04.3), python3-lxml (>= 4.5.0-1ubuntu0.5), python3-numpy (>= 1:1.17.4-5ubuntu3.1), python3-future (>= 0.18.2-2ubuntu0.1), libunwind-dev (>= 1.2.1-9ubuntu0.1)"/g' ../package.json

# Build and install Debian package:
npm run package && dpkg -i ../rpanion-server_*_arm64.deb

# Set IP address for eth0 connection to peer to MavLink network (can be changed):
nmcli connection modify 'Wired connection 1' ipv4.addresses 192.168.144.100/24 ipv4.gateway 192.168.144.1

# === Not needed??? ===

# # Install the required packages:
# apt install -y gstreamer1.0-libav libopus0 gstreamer1.0-plugins-good libgstrtspserver-1.0-dev gstreamer1.0-plugins-base-apps
# apt install -y gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad python3-netifaces
# apt install -y network-manager python3 python3-dev python3-gst-1.0 python3-pip dnsmasq git ninja-build jq
# apt install -y libxml2-dev libxslt1-dev python3-lxml python3-numpy python3-future gpsbabel zip
# apt install -y hostapd
# curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
# # pip3 install --upgrade --root-user-action kms+ libcamera 

# # If running on RasPiOS, install the libcamera drivers:
# apt install -y gstreamer1.0-libcamera python3-picamera2 python3-libcamera python3-kms++


# # Grab newer versions of Rpanion Server dependencies:

# # https://launchpad.net/ubuntu/+source/gst-rtsp-server1.0/1.20.1-1/+build/23243786/+files/

# cat << EOF > /etc/apt/sources.list.d/ubuntu22.list
# deb http://ports.ubuntu.com/ubuntu-ports/ jammy main restricted universe multiverse
# # deb-src http://ports.ubuntu.com/ubuntu-ports/ jammy main restricted universe multiverse

# deb http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted universe multiverse
# # deb-src http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted universe multiverse

# deb http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse
# # deb-src http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse

# deb http://ports.ubuntu.com/ubuntu-ports/ jammy-backports main restricted universe multiverse
# # deb-src http://ports.ubuntu.com/ubuntu-ports/ jammy-backports main restricted universe multiverse
# EOF

# # Pin Python before upgrading packages from Jammy repos:
# cat << EOF > /etc/apt/preferences.d/pin-python

# Package: python3
# Pin: version 3.8.2-0ubuntu2
# Pin-Priority: 1001

# Package: python3-dev
# Pin: version 3.8.2-0ubuntu2
# Pin-Priority: 1001

# Package: python3-pip
# Pin: version 20.0.2-5ubuntu1.11
# Pin-Priority: 1001
# EOF

# mv /etc/apt/sources.list  /etc/apt/.sources.list

# apt update
# apt install -y gstreamer1.0-plugins-good gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad network-manager libunwind-dev

# mv /etc/apt/sources.list.d/ubuntu22.list /etc/apt/sources.list.d/.ubuntu22.list
# mv /etc/apt/.sources.list  /etc/apt/sources.list

# apt update
# apt install --fix-broken -y

# # Grab Rpanion Server Debian package and install:
# wget https://github.com/stephendade/Rpanion-server/releases/download/v0.11.4/rpanion-server_0.11.4_arm64.deb
# dpkg -i rpanion-server_0.11.4_arm64.deb

# apt remove -y update-manager-core

# ===============================================