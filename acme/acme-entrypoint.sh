#!/bin/sh

for DOMAIN in $DOMAINS; do
  if [ ! -f "/acme.sh/${DOMAIN}/${DOMAIN}.cer" ]; then
    /usr/local/bin/--issue \
      -d "${DOMAIN}" \
      -w "/acme-challenge/${DOMAIN}" \
      || { echo "Could not issue certificate for ${DOMAIN}"; exit 1; }
  fi

  2>/dev/null mkdir /ssl/${DOMAIN}
  /usr/local/bin/--install-cert -d ${DOMAIN} \
    --cert-file /ssl/${DOMAIN}/cert.pem \
    --key-file /ssl/${DOMAIN}/key.pem \
    --fullchain-file /ssl/${DOMAIN}/fullchain.pem \
    || { echo "Could not deploy certificate for ${DOMAIN}"; exit 1; }
done

exec /entry.sh daemon
