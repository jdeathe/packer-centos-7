#!/bin/bash -e

/bin/echo '--> Adding cloud-init datasources_list.'
/usr/bin/tee \
  /etc/cloud/cloud.cfg.d/10_datasource_list.cfg \
  1> /dev/null \
  <<-EOF
datasource_list: [
  NoCloud,
  ConfigDrive,
  OpenNebula,
  Azure,
  AltCloud,
  OVF,
  MAAS,
  GCE,
  CloudStack,
  OpenStack,
  Ec2,
  CloudSigma,
  SmartOS,
  None,
]
EOF
