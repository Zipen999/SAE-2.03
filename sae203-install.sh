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
	vdn-ssh root@$1 ' apt install -y nfs-kernel-server 
	if [ $? = 0 ] ; then
		echo "============================="
		echo "installation NFS reussi"
		echo "============================="
	else
		echo " !! probleme dinstallation NFS !!" >&2
		exit
	fi' #Command used for installing the NFS service
}

ftp() {
	echo "Installation FTP ..."
	vdn-ssh root@$1 ' apt-get install -y ftp
	if [ $? = 0 ] ; then
		echo "============================="
		echo "installation FTP reussi"
		echo "============================="
	else
		echo " !! probleme dinstallation FTP !!" >&2
		exit
	fi' #Command used for installing the ftp service
}

apache2() {
	echo "Installation Apache2 ..."
		vdn-ssh root@$1 '
			#Command used for installing the apache2 service and lynx which is used for viewing web pages in a terminal
		apt-get install -y apache2 lynx
		if [ $? = 0 ] ; then
			echo "============================="
			echo "installation apache2 reussi"
			echo "============================="
		else
			echo " !! probleme dinstallation apache2 !!" >&2
			exit
		fi
 
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
	vdn-ssh root@$1 'apt-get install -y apache2-utils squid
	if [ $? = 0 ] ; then
		echo "============================="
		echo "installation squid proxy reussi"
		echo "============================="
	else
		echo " !! probleme dinstallation squid proxy !!" >&2
		exit
	fi' #Command used for installing the squid proxy service
}

pihole() {

	echo "Installation pihole Proxy ..."
	vdn-ssh root@$1 '
	# Install curl
	apt-get install curl
	codeCurl=$?


	# Install pihole
	curl -sSL https://install.pi-hole.net | bash
	codePihole=$?

	# Install unbound
    apt install unbound -y > /dev/null
    codeUnbound=$?

    # We check if all the required installations succeeded.
	if [ $codeCurl = 0 ] && [ $codePihole = 0 ] && [ $codeUnbound = 0 ] ; then
		echo "============================="
		echo "installation pihole reussi"
		echo "============================="
	else
		echo " !! probleme dinstallation pihole !!" >&2
		exit
	fi'
}

# main
nfs $HOSTNAME
ftp $HOSTNAME
apache2 $HOSTNAME
squid $HOSTNAME
pihole $HOSTNAME