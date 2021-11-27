#!/bin/sh

for DOMAIN in $DOMAINS; do
  if [ ! -f "/acme.sh/${DOMAIN}/${DOMAIN}.cer" ]; then
    /usr/local/bin/--issue \
      -d "${DOMAIN}" \
      -w "/acme-challenge/${DOMAIN}" \
        || { echo "Could not issue certificate for ${DOMAIN}"; exit 1; }
  fi

  # prepopulate key/cert at install destination w/ appropriate permissions
  2>/dev/null mkdir "/ssl/${DOMAIN}"
  touch "/ssl/${DOMAIN}"/{fullchain.pem,cert.pem,key.pem}
  chmod 0600 "/ssl/${DOMAIN}/key.pem"
  chown -R ${INSTALL_UID}:${INSTALL_GID} "/ssl/${DOMAIN}"

  /usr/local/bin/--install-cert \
    -d "${DOMAIN}" \
    --cert-file "/ssl/${DOMAIN}/cert.pem" \
    --key-file "/ssl/${DOMAIN}/key.pem" \
    --fullchain-file "/ssl/${DOMAIN}/fullchain.pem" \
      || { echo "Could not install certificate for ${DOMAIN}"; exit 1; }
done

exec /entry.sh daemon
