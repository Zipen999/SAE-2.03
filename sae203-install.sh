#!/bin/sh

#takes one argument,$1 should be the machines name
if [ -z "$1" ] ; then #Checks if the first argument is empty
	echo "Veuillez saisir le nom de machine en argument" >&2
	exit 2
fi

if [ ! `vdn-ssh root@$1` ]; then #Checks if the first argument isn't the same as our virtual machines name
    echo "Mauvais nom de machine !" >&2
    exit 2
fi

HOSTNAME=$1

nfs() {
	echo "Installation NFS ..."
	vdn-ssh root@$1 ' apt install -y nfs-kernel-server' #Command used for installing the NFS service
}

ftp() {
	echo "Installation FTP ..."
	vdn-ssh root@$1 ' apt-get install -y ftp' #Command used for installing the ftp service
}

apache2() {
	echo "Installation Apache2 ..."
		vdn-ssh root@$1 '
			#Command used for installing the apache2 service and lynx which is used for viewing web pages in a terminal
		apt-get install -y apache2 lynx
 
 		# Web page content
		cat << EOF > /var/www/html/index.html
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<center><h1>Bienvenue sur le serveur Web de '$1'</h1></center>
</body>
</html>
EOF
	'
}

squid() {
	echo "Installation Squid Proxy ..."
	vdn-ssh root@$1 'apt-get install -y apache2-utils squid3' #Command used for installing the squid proxy service
}

# main
nfs $HOSTNAME
ftp $HOSTNAME
apache2 $HOSTNAME
squid $HOSTNAME