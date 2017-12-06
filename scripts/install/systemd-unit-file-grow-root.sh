#!/bin/bash -e

/bin/echo '--> Install grow-root.service.'
/usr/bin/systemctl daemon-reload
/usr/bin/systemctl enable \
  -f \
  grow-root.service
