#!/bin/bash

echo 'Stopping Agent'
systemctl stop elastic-agent
echo 'Disabling agent'
systemctl disable elastic-agent

echo 'Purging Agent'
apt purge elastic-agent -y

echo 'Removing directories'
rm -rf /var/lib/elastic-agent
rm -rf /etc/elastic-agent
rm /usr/local/share/ca-certificates/ca.crt

echo 'Updating certs'
update-ca-certificates
