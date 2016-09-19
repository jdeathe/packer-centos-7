#!/bin/bash -e

/bin/echo '--> Configuring SSHD.'
/bin/sed -i \
  -e 's~^PasswordAuthentication yes~PasswordAuthentication no~g' \
  -e 's~^#PermitRootLogin yes~PermitRootLogin no~g' \
  -e 's~^#UseDNS yes~UseDNS no~g' \
  /etc/ssh/sshd_config
