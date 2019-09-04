#!/bin/bash -e

/bin/echo '--> Stopping logging services.'
/sbin/service auditd stop
/usr/bin/systemctl stop rsyslog.service

/bin/echo '--> Truncate log files.'
/bin/find /var/log -type f \
  -exec /usr/bin/truncate -s 0 {} \;
