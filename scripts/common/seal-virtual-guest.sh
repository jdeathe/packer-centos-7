#!/bin/bash -e

/bin/echo '--> Sealing virtual-guest.'

/bin/echo '---> Removing SSH host keys.'
/bin/rm -f /etc/ssh/ssh_host_*

/bin/echo '---> Generalising hostname.'
/bin/sed -i \
  -e 's~^HOSTNAME=.*$~HOSTNAME=localhost.localdomain~g' \
  /etc/sysconfig/network

/bin/echo '---> Removing udev rules.'
/bin/rm -rf /etc/udev/rules.d/70-*

/bin/echo '---> Generalising network device configuration.'
/bin/sed -i \
  -e 's~^DHCP_HOSTNAME=.*$~DHCP_HOSTNAME="localhost.localdomain"~' \
  -e '/^HWADDR=/d' \
  -e '/^UUID=/d' \
  /etc/sysconfig/network-scripts/ifcfg-eth*

/bin/echo '---> Removing machine-id.'
  :> /etc/machine-id
