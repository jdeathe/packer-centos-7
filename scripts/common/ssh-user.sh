#!/bin/bash -e

SSH_USER="${SSH_USER:-centos}"
SSH_USER_AUTHORIZED_KEYS="${SSH_USER_AUTHORIZED_KEYS:-}"
SSH_USER_HOME="${SSH_USER_HOME:-centos}"
SSH_USER_PASSWORD="${SSH_USER_PASSWORD:-centos}"
SSH_USER_SHELL="${SSH_USER_SHELL:-/bin/bash}"
SSH_USER_SUDO="${SSH_USER_SUDO:-ALL=(ALL) ALL}"

/bin/echo '--> Adding SSH user.'
/usr/sbin/useradd \
  -m \
  -d ${SSH_USER_HOME} \
  -s ${SSH_USER_SHELL} \
  ${SSH_USER}

/bin/echo '---> Setting password.'
/bin/echo "${SSH_USER}:${SSH_USER_PASSWORD}" | \
  /usr/sbin/chpasswd

/bin/echo '---> Populating authorized_keys.'
/bin/mkdir -pm 0700 ${SSH_USER_HOME}/.ssh
/bin/echo "${SSH_USER_AUTHORIZED_KEYS}" \
  > ${SSH_USER_HOME}/.ssh/authorized_keys
/bin/chown -R ${SSH_USER}:${SSH_USER} ${SSH_USER_HOME}/.ssh
/bin/chmod 0600 ${SSH_USER_HOME}/.ssh/authorized_keys

/bin/echo '---> Restoring SELinux context'
/sbin/restorecon -R ${SSH_USER_HOME}/.ssh

/bin/echo '--> Configuring sudoer access.'
/bin/echo "${SSH_USER} ${SSH_USER_SUDO}" \
  > /etc/sudoers.d/${SSH_USER}
/bin/chmod 0440 /etc/sudoers.d/${SSH_USER}
