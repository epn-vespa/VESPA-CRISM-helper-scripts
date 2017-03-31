# Running DaCHS environment with Docker

## Presentation

This folder aims to provide a complete environment to serve epntap services through DaCHS software, by building 3 docker images:
- the `dachs` container, running the DaCHS software;
- the `postgres` container, running the epntap database;
- the `awstats` container, running AWStats in order to provide statistics about your services.

This images are built from the [docker-compose](docker-compose.yml) file.

## env file

This project is developped with in mind that the only file you have to edit is the [.env](.env) configuration file:

- `TAG` : the tag of you containers; this allow you to build several instances of DaCHS containers, in order to have - for instance - a production container and a test container;
- `SERVERNAME` : The server name;
- `DOMAIN` : The server domain;
- `DACHS_PORT` : The web port used by the DaCHS software;
- `AWSTATS_PORT` : The web port used by awstats;
- `PSQL_PORT` : The port used by Postgres (i.e. if you want to access it from PGAdmin);
- `CRONTAB` : the [crontab string](http://www.nncron.ru/help/EN/working/cron-format.htm) used to update awstats statistics;
- `SERVICE_PATH` : The (absolute or relative) path of your services folder;

## Setting up Docker

1. Install [Docker](https://docs.docker.com/engine/installation/);
2. And [Docker-compose](https://docs.docker.com/compose/install/);
3. and then [configure some other things](https://docs.docker.com/engine/installation/linux/linux-postinstall/).

Depending on your network, you may want to configure the DNS used by Docker:

First, check if you need it:

	docker run -it debian /bin/bash # Dowload the Debian image, run the container and a shell
	ping 128.31.0.62 # Debian archives IP

You should received all packets. But then ping it from the domain name:

	ping deb.debian.org # Debian archives URL

**If you don't receive the packet, you must configure the Docker DNS**, by add `--dns` option when starting the Docker daemon.

> **Note:** To know the DNS server used on you machine, type:
>
>     nmcli device show <network_name> # example : "enp0s25"

**First case: your system uses `systemd`:**

	sudo nano /lib/systemd/system/docker.service

Look for the line begining with `ExecStart` and add the dns options, for example:

	ExecStart=/usr/bin/dockerd -H fd:// --dns=10.10.131.1 --dns=10.10.131.2

**Second case: Your system doesn't use systemd:**

Just add the key `DOCKER_OPTS` in the file `/etc/default/docker`:

	sudo bash -c "echo 'DOCKER_OPTS=\"--dns 8.8.8.8 --dns 8.8.4.4\"' >> /etc/default/docker"

## Setting up your containers

1. Edit your [.env](.env) file as described above;
2. Put your services in the *services* folder (described in the `.env` file), with one folder by service;
3. Build the containers with `docker-compose up` command;
4. Check if DaCHS and awstats are running on `127.0.0.1:<port_specified_in_env_file>`.

> **Note:** you can also do step `3.` with: `docker-compose up -d`, in this way you keep you terminal open to run other commands such as `docker exec`. You can then log a container with `docker logs <container_name>`.

# Filling data

Just execute the `dachs_pub.sh` script from the dachs container:

	docker exec -it <container_name> ./dachs_pub.sh <service_name>

## Hacking your containers

If you want to do some things in a container (for test purposes), type:

	docker exec -it dachs_prod /bin/bash

Note that the Docker philosophy is to don't have to touch a container once it is built. **If you need permanent changes, you must edit your DockerFile** ([this one](dachs/DockerFile), [this one](postgres/DockerFile) or [this one](awstats/DockerFile)).

Each time you modify your Dockerfile, you need to remove the old images and build again you images:

For example if you edit the `dachs` Dockerfile:

	docker rm dachs_prod
	docker-compose up --build

If you think your modification could be useful for others, please [post a new issue](https://github.com/epn-vespa/DaCHS-for-VESPA/issues).

## DaCHS update

Since Docker build images using layers (it build the image only from where the the Dockerfile has been edited), if the DaCHS software has been updated, you need to remove the Docker images and rebuild them:

	docker rmi dachs_prod postgres_prod
	Docker-compose up

Note that the Dockerfile replaces the DaCHS epntap2 mixin by [its last version](https://raw.githubusercontent.com/epn-vespa/DaCHS-for-VESPA/master/mixin-EPN-TAP-2.0/epntap2.rd-2.xml) published in the VESPA GitHub.

# Complete workflow example

Prerequies : [Docker and docker-compose are installed and configured](#setting-up-your-containers).

First, clone the DaCHS-for-VESPA from GitHub:

	git clone https://github.com/epn-vespa/DaCHS-for-VESPA.git
	cd DaCHS-for-VESPA/docker

Now let's try to publish the [illu67 service](https://github.com/epn-vespa/DaCHS-for-VESPA/tree/master/q.rd_examples/illu67p).

	mkdir services
	cp -r ../q.rd_examples/illu67p/ ./services/illu67p/

The *services* folder should be like this:

	└── services
	    └── illu67p
	        ├── illu67p_pub.py
	        └── illu67p_q.rd

Now build you docker images:

	docker-compose up

When you see `dachs_prod  | DaCHS is running!`, open a new terminal and type

	docker exec -it dachs_prod ./dachs_pub.sh illu67p

When the data are imported, check the [table information page](http://127.0.0.1/__system__/dc_tables/show/tableinfo/illu67p.epn_core) and the go to the [ADQL form page](http://localhost/__system__/adql/query/form) and type:

	select top 10 * from illu67p.epn_core

Is it working? Congration!!! You can now publish you own service.
