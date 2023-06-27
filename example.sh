source ci_utils.sh

export BASTION_HOST=x.x.x.x
export BASTION_KEY=/path/to/pem/file/file.pem
export BASTION_USER=ec2user
make_available -host somehost.private.com -ports 80,443

#or for bounding tunnel to different local ip
#make_available -host somehost.private.com -ports 80,443 -localip 127.0.0.2

#for bounding to remote ip instead of dns name
#make_available -ip y.y.y.y -ports 80,443

