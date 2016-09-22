#!/bin/bash -e

/bin/echo '--> Adding cloud-init datasource settings.'
/usr/bin/tee \
  /etc/cloud/cloud.cfg.d/10_datasource.cfg \
  1> /dev/null \
  <<-EOF
datasource: 
   Ec2: 
     timeout: 10
     max_wait: 60
EOF
