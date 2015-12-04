# softlayer_vyatta

On reboot Vyatta overwrites some files in /etc/ so configuration changes to some files in this directory are not persisted. In order
to preserve posthook script capability of including files in /etc/ipsec.d/ add the following to your /etc/rc.local file.

# Add postconf capability
curl -s https://raw.githubusercontent.com/bmcsheehy/softlayer_vyatta/master/install.sh | bash
