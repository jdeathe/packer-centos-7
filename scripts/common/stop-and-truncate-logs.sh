#!/bin/bash -e

/bin/echo '--> Stopping logging services.'
/usr/bin/systemctl stop auditd.service
/usr/bin/systemctl stop rsyslog.service

/bin/echo '--> Truncate log files.'
/bin/find /var/log -type f \
  -exec /usr/bin/truncate -s 0 {} \;
