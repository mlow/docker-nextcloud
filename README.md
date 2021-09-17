# docker-nextcloud
A docker-compose project useful for quickly bringing up a
[Nextcloud](https://nextcloud.com) server with auto-fetching and renewing
TLS certificates thanks to [acme.sh](https://acme.sh).

## Setup
First, have [Docker](https://docs.docker.com/get-docker/) and
[docker-compose](https://docs.docker.com/compose/install/) installed.

### Clone this repository.
```shell
git clone https://github.com/mlow/docker-nextcloud

cd docker-nextcloud
```

### Copy .env.example to .env
```shell
cp .env.example .env

# then edit .env to appropriate values
```

### Do some preparations...
```shell
# Get our variables
source .env

# Create requisite dirs
mkdir -p "${DATA_ROOT}"/{acme-challenge,acme.sh,ssl,postgres,nextcloud}

# Register account for certs
docker run -it --rm -v "${DATA_ROOT}/acme.sh:/acme.sh" neilpang/acme.sh \
	acme.sh --register-account -m "${ACME_EMAIL}"

# Prepare nginx config
sed -i -e "s/example.com/${DOMAINS}/g" nginx/sites-enabled/nextcloud.conf
```

### Start!
```shell
docker-compose up
```