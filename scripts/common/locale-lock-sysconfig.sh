#!/bin/bash -e

/bin/echo '--> Locking locale.'
/usr/bin/chattr +i /etc/locale.conf

# Reject SSH locale environment variables
/bin/sed -i \
  -e 's~^AcceptEnv \(.*\)~#AcceptEnv \1~g' \
  /etc/ssh/sshd_config
