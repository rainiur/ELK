#!/bin/bash

echo 'Stopping Agent (May take a while be patient)'
systemctl stop elastic-agent
echo 'Disabling agent'
systemctl disable elastic-agent

echo 'Purging Agent'
dpkg -P elastic-agent

echo 'Removing directories'
rm -rf /var/lib/elastic-agent
rm -rf /etc/elastic-agent
rm /usr/local/share/ca-certificates/ca.crt

echo 'Updating certs'
update-ca-certificates
