#!/bin/bash -e

GUEST_LANG="${GUEST_LANG:-en_US.UTF-8}"

/bin/echo '--> Locking locale.'
/usr/bin/chattr +i /etc/sysconfig/i18n

# Reject SSH locale environment variables
/bin/sed -i \
  -e 's~^AcceptEnv \(.*\)~#AcceptEnv \1~g' \
  /etc/ssh/sshd_config
