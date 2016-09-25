#!/bin/bash -e

/bin/echo '--> Adding cloud-init preserve_hostname settings.'
/usr/bin/tee \
  /etc/cloud/cloud.cfg.d/10_preserve_hostname.cfg \
  1> /dev/null \
  <<-EOF
preserve_hostname: true
EOF

