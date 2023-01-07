# dot files
This project aims to be a multi-OS collection of templates of configuration files and Shell script that help the users.

# Contents
* [Check IP](#check-ip)
  - [.env](#env)
  - [check_IP.service](#check_ipservice)
  - [check_IP.sh](#check_ipsh)
  - [check_IP.timer](#check_iptimer)
  - [install.sh](#installsh)
* [Desktop entries](#desktop-entries)
* [Makefile](#makefile)
* [Service Unit](#service-unit)
* [Shell scripts](#shell-scripts)
* [Pi-hole](#pi-hole)
  - [docker/.env](#dockerenv)
  - [docker/build.sh](#dockerbuildsh)
  - [docker/unbound.sh](#dockerunboundsh)
  - [install.sh](#installsh)
  - [pihole.service](#piholeservice)
  - [pihole.sh](#piholesh)

# Check IP
The [check_IP](https://github.com/giulio-coa/dotfiles/tree/master/check_IP) project have the aims to retrieve every change of the IP of the default gateway of a Local Area Network (LAN); it is structured as
```
  /
    .env
    check_IP.service
    check_IP.sh
    check_IP.timer
    install.sh
```

## .env
This is the enviroment file that provides the FTP credentials to the Shell script.

## check_IP.service
This is the `systemd`'s Service Unit that run the Shell script at boot time.

## check_IP.sh
This is the core of the project; this Shell script check, through [ip6.me](http://ip6.me/), the IP of the default gateway of the LAN and print it or, through an FTP connection, post if on a site.

## check_IP.timer
This is the `systemd`'s Timer Unit that run the Shell script every `10` minute from the first execution (boot time).

## install.sh
The installation file; it create the links for the correct function of the System Unit (Service and Timer).

# Desktop entries
The [desktop entries](https://github.com/giulio-coa/dotfiles/tree/master/desktop_entries) in this repository are intended to provide, where they may be missing (see KDE), the basic icons that an OS has.

# Makefile
The `makefile` into the repository is a template for a generic project in C with the following structure
```
  /
    header/
            lib.h
            lib.gch
    source/
            lib.c
            main.c
  lib.o
  main.o
```

# System Unit
The [`example.service`](https://github.com/giulio-coa/dotfiles/blob/master/lib/systemd/system/example.service) file is an example of a Service Unit used by `systemd`.

The file have a path that emulate the absolute path where it must be positioned; in add, it must be linked into `/etc/systemd/system` (`ln -s /lib/systemd/system/example.service /etc/systemd/system/example.service`).

# Shell scripts
The Shell scripts into this repository are a sort of libraries for the Shell, each with a specific purpose (`pacman.sh` -> better interface with `pacman`, etc.).

# Pi-hole
The [Pi-hole](https://github.com/giulio-coa/dotfiles/tree/master/Pi-hole) project have the aims to run a Pi-hole Docker Container as recursive DNS server; it is structured as
```
  /
    docker/
            .env
            build.sh
            docker-compose.yml
            Dockerfile
            unbound.sh
    install.sh
    pihole.service
    pihole.sh
```

## docker/.env
This is the enviroment file that provides the configuration parameters to the Pi-hole Docker Container.

## docker/build.sh
This is the Shell script that build the Pi-hole Docker Container.

## docker/unbound.sh
This is the Shell script that installs and configures Unbound into the Pi-hole Docker Container.

## install.sh
The installation file; it create the links for the correct function of the System Unit and the directories for the correct function of the recursive DNS server.

## pihole.service
This is the `systemd`'s Service Unit that run the Shell script at boot time.

## pihole.sh
This is the Shell script that starts the Pi-hole Docker Container.
