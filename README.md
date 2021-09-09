# ELK Stack Setup

I went through a lot trying to figure out how to set up an ELK Stack with the new Fleet Agents. The documentation for the different pieces were a lot of different places. I decided to put it into one place. As I add the different pieces I will include them. I really hope this helps someone getting their system up and running.

Currently only agent scripts but I will be loading others as quickly as I can.

The agent script will not work for fleet server installs. Use the install script provided by the Kibana interface.

## Filebeat YAML

### Threat Intel
Use this site to get get OTX configured
https://www.elastic.co/blog/ingesting-threat-data-with-threat-intel-filebeat-module