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

### Set up .env
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

# Pre-create final cert/key files with appropriate permissions
for DOMAIN in ${DOMAINS}; do
  mkdir "${DATA_ROOT}/ssl/${DOMAIN}"
  touch "${DATA_ROOT}/ssl/${DOMAIN}"/{fullchain.pem,cert.pem,key.pem}
  chmod 0600 "${DATA_ROOT}/ssl/${DOMAIN}/key.pem"
  chown -R 101:101 "${DATA_ROOT}/ssl"
done

# Optional: Switch default CA from ZeroSSL to LetsEncrypt
docker run --rm -v "${DATA_ROOT}/acme.sh:/acme.sh" neilpang/acme.sh \
	acme.sh --set-default-ca --server letsencrypt

# Register account with CA
docker run --rm -v "${DATA_ROOT}/acme.sh:/acme.sh" neilpang/acme.sh \
	acme.sh --register-account -m "${ACME_EMAIL}"
```

### Start!
```shell
docker-compose up
```
