#!/bin/bash -e

/bin/echo '--> Replacing network configuration name to device.'
/bin/sed -i \
  -e 's~^NAME="eth\([0-9][0-9]*\)"$~DEVICE="eth\1"~' \
  /etc/sysconfig/network-scripts/ifcfg-eth*
