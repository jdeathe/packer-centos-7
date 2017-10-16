#!/bin/bash -e

/bin/echo '--> Adding cloud-init logging output.'
if ! /bin/grep -q 'output: {' \
  /etc/cloud/cloud.cfg.d/05_logging.cfg
then
  /usr/bin/tee \
    -a \
    /etc/cloud/cloud.cfg.d/05_logging.cfg \
    1> /dev/null \
  <<-EOF
output: { all: "| tee -a /var/log/cloud-init-output.log" }
EOF
fi