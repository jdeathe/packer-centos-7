#!/bin/bash -e

/bin/echo '--> Adding AWS cloud-init datasources_list.'
/usr/bin/tee \
  /etc/cloud/cloud.cfg.d/10_datasource_list.cfg \
  1> /dev/null \
  <<-EOF
datasource_list: [
  NoCloud,
  ConfigDrive,
  Ec2,
  None,
]
EOF
