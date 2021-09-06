#!/bin/bash
#########################################################
#  Elastic Agent Ubuntu Install Steps using apt
#		by David Walden (Rainiur)
#  These steps will: 
#  Add the Elastic Repository to apt
#  Download and install the elastic agent
#  Download the certificate from the server via scp
#       (This script will register a self-signed cert if you are using a 3rd party signed cert delete --insecure from the elastic-agent install)
#  Add the certificate
#  And run the install to register it to your Fleet manager
#
#  You will need the following
#		- ssh credentials, filename and IP for the server with your cert 
#			(best to copy the cert to the root directory of the user)
#		- IP address of your Fleet Server
#		- Token for the policy to apply to the system
#
#########################################################

username='<ssh username>'
certIP='<IP to cert server>'
fleetIP='<IP of Fleet Server>'
token='<token from Fleet Manager>'

## Download the cert and add the the shared certs directory
# scp <username>@<Server IP>:<filename i.e. ca.crt> .
# mv ca.crt /usr/local/share/ca-certificates/
# OR #
scp $username@$certIP:ca.crt /usr/local/share/ca-certificates/

## Add the cert
update-ca-certificates

## Download and install the debian tarball image
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-7.14.1-amd64.deb
dpkg -i elastic-agent-7.14.1-amd64.deb

## Since the agent was installed via apt we just need to enroll with the Fleet Server
elastic-agent enroll -f --url=https://$fleetIP:8220 --insecure --enrollment-token=$token

## Restart and enable the service
systemctl start elastic-agent.service
systemctl enable elastic-agent.service
