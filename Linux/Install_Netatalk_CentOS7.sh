#!/bin/sh
# Install Time Machine service on CentOS 7
# fonte: https://gist.github.com/darcyliu/f3db52d6d60ef4f4f4ef
# http://netatalk.sourceforge.net/wiki/index.php/Netatalk_3.1.7_SRPM_for_Fedora_and_CentOS
# http://confoundedtech.blogspot.com/2011/07/draft-draft-ubuntu-as-apple-time.html


yum install netatalk -y

echo" [Global]

log file = /var/log/afpd.log
log level = default:error
uam list = uams_dhx.so,uams_dhx2.so
afpstats = yes
mimic model = RackMac
map acls = mode

[Dados]

path = /mnt/storage/dados
valid users = acesso 
file perm = 0664
directory perm = 2775" >> /etc/netatalk/afp.conf

systemctl enable netatalk
systemctl start netatalk