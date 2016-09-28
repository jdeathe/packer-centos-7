#!/bin/bash -e

/bin/echo '--> Adding cloud-init datasource settings.'
/usr/bin/tee \
  /etc/cloud/cloud.cfg.d/10_datasource.cfg \
  1> /dev/null \
  <<-EOF
datasource:
  CloudStack:
     timeout: 15
     max_wait: 30
  Ec2:
    timeout: 15
    max_wait: 30
EOF
