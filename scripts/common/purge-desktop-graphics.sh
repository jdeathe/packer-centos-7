#!/bin/bash -e

/bin/echo '--> Purging desktop graphics.'
/bin/find /usr/share/{backgrounds,kde4,wallpapers} \
  -type f -regextype posix-extended -regex '.*\.(jpg|png)$' -delete
