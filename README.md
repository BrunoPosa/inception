# Inception
hive school project

## Introduction

This project enhances system administration skills using Docker. Multiple Docker images will be virtualized within a VM.

## Guidelines

* The project must be completed in a Virtual Machine.
* All configuration files should be placed in srcs/.
* A Makefile must set up the application via docker-compose.yml.
* Research on Docker concepts may be necessary.

## Mandatory Setup

* Each service runs in a dedicated container with a matching image name.
* Alpine/Debian (penultimate stable version) must be used.
* Individual Dockerfiles should be written and referenced in docker-compose.yml via Makefile.
* Pre-built images (except Alpine/Debian) are not allowed.

## Required Services

1. NGINX (TLSv1.2/1.3 only).
2. WordPress + PHP-FPM (configured, no NGINX).
3. MariaDB (without NGINX).
4. Volumes for WordPress database and files.
5. Docker Network to link services.

## Constraints

* Containers must auto-restart on failure.
* network: host, --link, and links: cannot be used.
* Infinite loops (tail -f, bash, sleep infinity) must be avoided.
* The WordPress admin username must not contain admin or administrator.
* Volumes must be stored in /home/<login>/data/.
* The domain <login>.42.fr must point to the local IP.
* NGINX must be the sole entry point via port 443, using TLSv1.2/1.3.