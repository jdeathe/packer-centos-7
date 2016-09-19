#!/bin/bash -e

/bin/echo '--> Removing default requiretty from sudoers (no PasswordAuthentication).'
/bin/sed -i \
  -e 's~\(.*\) requiretty$~#\1requiretty~' \
  /etc/sudoers
