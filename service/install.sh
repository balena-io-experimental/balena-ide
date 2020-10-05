#!/bin/sh

REPO_URL="https://github.com/balena-io-playground/balena-ide"

# Remount fs as read/write
mount -o remount,rw /

# Grab service files
mkdir /etc/balena-ide
mkdir /usr/lib/balena-ide

curl "$REPO_URL/tree/master/service/balena-ide-healthcheck" --output /usr/lib/balena-ide/balena-ide-healthcheck
curl "$REPO_URL/tree/master/service/balena-ide.service" --output /lib/systemd/system/balena-ide.service
curl "$REPO_URL/tree/master/service/start-balena-ide" --output /usr/bin/start-balena-ide
curl "$REPO_URL/tree/master/service/ide.conf" --output /etc/balena-ide/ide.conf

chmod +x /usr/bin/start-balena-ide
chmod +x /usr/lib/balena-ide/balena-ide-healthcheck

# Enable service and reboot
systemctl enable balena-ide
reboot