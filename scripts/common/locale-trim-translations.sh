#!/bin/bash -e

GUEST_LANG="${GUEST_LANG:-en_US.UTF-8}"

/bin/echo '--> Removing locale (translation) files for unused languages.'
/bin/find /usr/share/locale \
  -mindepth 1 \
  -maxdepth 1 \
  -type d \
  -regextype posix-extended \
  ! -regex ".*\/(en|en_US|${GUEST_LANG%%_*}|${GUEST_LANG%%.*})(@.+)?$" \
  -exec /bin/find -- {} -type f -name "*.mo" -delete \;
