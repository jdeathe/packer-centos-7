#!/bin/bash -e

/bin/echo '--> Installing tuned (virtual-guest).'
/usr/bin/yum -y install \
  tuned
/usr/bin/systemctl enable tuned
/usr/sbin/tuned-adm profile \
  virtual-guest
