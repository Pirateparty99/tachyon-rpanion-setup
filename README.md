# Tachyon-Rpanion-Setup
This repo was created to hold a Bash script created to deploy the [Rpanion Server](https://www.docs.rpanion.com/software/rpanion-server) on a [Particle Tachyon](https://www.particle.io/tachyon/) Single Board Computer (SBC). Rpanion Server was created for web-based configuration of vehicles using the [MavLink](https://mavlink.io/) protocol from a companion computer.

## Prerequisites
This repo assumes the Tachyon SBC has already been setup. To setup the Tachyon follow the official [setup guide](https://developer.particle.io/tachyon/setup/install-setup). This script was tested on the headless installation of the Tachyon OS, but presumably should work the same on the desktop installation.

# Installation
To deploy Rpanion Server simply run the command below:

```cd tachyon-rpanion-setup && chmod +x tachyon-rpanion-setup.sh && ./tachyon-rpanion-setup.sh```

### Note 
This repo is by no means a complete project nor is it a rewrite of the Rpanion Server project. It was created as I needed to create a script to configure Rpanion Server on a Tachyon board. The only modifications to the Rpanion Server codebase were made to solve an error that caused the server to crash when installed from the built Debian package (The error was "Uncaught exception: TypeError: res.status is not a function at /usr/share/rpanion-server/app/server/index.js:337:25" error).