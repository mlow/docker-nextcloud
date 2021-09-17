#!/bin/sh

set -e
for DOMAIN in $DOMAINS; do
  if [ ! -d "/acme.sh/${DOMAIN}" ]; then
    /usr/local/bin/--issue \
	-d "${DOMAIN}" \
	-w "/acme-challenge/${DOMAIN}" \
	--keylength ec-256 \
      || { echo "Could not issue certificate for ${DOMAIN}"; exit 1; }
  fi
  
  if [ ! -d "/ssl/${DOMAIN}" ]; then
    mkdir /ssl/${DOMAIN}
    /usr/local/bin/--install-cert -d ${DOMAIN} \
      --cert-file /ssl/${DOMAIN}/cert.pem \
      --key-file /ssl/${DOMAIN}/key.pem \
      --fullchain-file /ssl/${DOMAIN}/fullchain.pem \
      || { echo "Could not deploy certificate for ${DOMAIN}"; exit 1; }
  fi
done

exec /entry.sh daemon
