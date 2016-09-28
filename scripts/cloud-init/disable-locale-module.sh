#!/bin/bash -e

/bin/echo '--> Disabling cloud-init locale module.'
/bin/sed -i \
  -e 's~^\([ ]*\)\(- locale\)$~\1#\2~' \
  /etc/cloud/cloud.cfg
