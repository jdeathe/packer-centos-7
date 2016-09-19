#!/bin/bash -e

GUEST_LANG="${GUEST_LANG:-en_US.UTF-8}"

/bin/echo '--> Removing locale (internationalisation) files for unused languages.'
/bin/find /usr/share/i18n/locales \
  -type f \
  -regextype posix-extended \
  \( ! -regex ".*\/(en_US|${GUEST_LANG%%.*})(@.+)?$" \
    -a -regex '.*\/[a-z][a-z]([a-z])?_[A-Z][A-Z](@.+)?$' \) \
  -delete
