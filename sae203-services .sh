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


testScp() {
	echo "testScp $@..."
	vdn-ssh test@$1'
	# Creates a dir and a text file to test the scp function
	if [ ! -f ~/scpTest/scpTEST.txt ] ; then
		mkdir ~/scpTest
		touch ~/scpTest/scpTEST.txt
		echo "=============================
SCP FONCTIONNEL
=============================" > ~/scpTest/scpTEST.txt
	fi
	'
	vdn-ssh root@$1 '
	# copies scpTEST.txt from test and shows the content of the file, if a "SCP FONCTIONNEL" text appears on the terminal then scp works correctly.
	scp test@'$1':~/scpTest/scpTEST.txt /tmp/
	cat /tmp/scpTEST.txt'
}

testSshfs() {
	echo "testSshfs $@..."
	vdn-ssh test@$1'
	# Creates a dir and a text file to test the sshfs function
	if [ ! -f ~/sshfsTest/sshfsTEST.txt ] ; then
		mkdir ~/sshfsTest
		touch ~/sshfsTest/sshfsTEST.txt
	fi
	'
	vdn-ssh root@$1 '
	# mounts the sshfsTest dir from test, if the command works then sshfs works correctly, we unmount it for future tests.
	sshfs test@'$1':~/sshfsTest
	if [ $? = 0 ] ; then
		echo "============================="
		echo "sshfs FONCTIONNEL"
		echo "============================="
	fi
	fusermount -u ~/sshfsTest'
}

testNfs() {
	echo "testNfs $@..."
	vdn-ssh root@$1 '
					echo "/overlays/ro/usr/share/doc '$1'(ro,sync,fsid=1,no_subtree_check)" > /etc/exports
					/etc/init.d/nfs-kernel-server restart
					if [ ! -d nfsTest ] ; then 
						mkdir nfsTest
					fi
					mount -t nfs '$1':/overlays/ro/usr/share/doc nfsTest
					if [ $? = 0 ] ; then
						echo "============================="
						echo "SERVICE NFS FONCTIONNEL"
						echo "============================="
					fi
					umount nfsTest
					' # allows debian-1 to only read the dir "/overlays/ro/usr/share/doc"
					# restarts the server in order to update the config file and does a mount test then unmounts for future tests
}

testFtp() {
	echo "testFtp $@..."
	vdn-ssh test@$1 '
	if [ ! -f testFTP/ftpStatus ] ; then 
		mkdir testFTP
		touch testFTP/ftpStatus
	fi' #Creates a file where we want our text to be pulled, skips this step if the file already exists.

	vdn-ssh root@$1 '
	if [ ! -f ftpTest/localFTP.txt ] ; then
		mkdir ftpTest
		touch ftpTest/localFTP.txt
	fi

	echo "=============================
SERVICE FTP FONCTIONNEL
=============================" > ftpTest/localFTP.txt

	echo "open '$1'
 	user test testZipen
 	put ~/ftpTest/localFTP.txt ~/testFTP/ftpStatus 
 	bye" > ftpTest/ftpcommands.txt

	ftp -n < ftpTest/ftpcommands.txt' # Creates a directory to test the FTP service, skips if the file is already present
	#ftpcommands.txt takes all the commands we want our ftp to execute, in here we send our local file content to our test user

	vdn-ssh test@$1 'cat testFTP/ftpStatus' # If this command shows "SERVICE FTP FONCTIONNEL" then ftp works
}

testApache2() {
	echo "testApache2 $@..."
	vdn-ssh test@$1 '
		if lynx -dump http://localhost | grep -q Bienvenue; then
			echo "============================="
			echo "SERVICE APACHE2 FONCTIONNEL"
			echo "============================="
			return 1
		fi
	'
}

testSquid() {
	echo "testSquid $@..."
	vdn-ssh root@$1 ' 
    touch /etc/squid/passwd

    # Setting up the config file with the correct options

    echo "http_port 3128
cache deny all
hierarchy_stoplist cgi-bin ?

access_log none
cache_store_log none
cache_log /dev/null

refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320

acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1

acl SSL_ports port 1-65535
acl Safe_ports port 1-65535
acl CONNECT method CONNECT
acl siteblacklist dstdomain "/etc/squid/blacklist.acl"
http_access allow manager localhost
http_access deny manager

http_access deny !Safe_ports

http_access deny CONNECT !SSL_ports
http_access deny siteblacklist
auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwd

auth_param basic children 5
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 2 hours
acl password proxy_auth REQUIRED
http_access allow localhost
http_access allow password
http_access deny all

forwarded_for off
request_header_access Allow allow all
request_header_access Authorization allow all
request_header_access WWW-Authenticate allow all
request_header_access Proxy-Authorization allow all
request_header_access Proxy-Authenticate allow all
request_header_access Cache-Control allow all
request_header_access Content-Encoding allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Expires allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Last-Modified allow all
request_header_access Location allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Content-Language allow all
request_header_access Mime-Version allow all
request_header_access Retry-After allow all
request_header_access Title allow all
request_header_access Connection allow all
request_header_access Proxy-Connection allow all
request_header_access User-Agent allow all
request_header_access Cookie allow all
request_header_access All deny all" > /etc/squid/squid.conf

    /usr/bin/touch /etc/squid/blacklist.acl

    #checks if our default port is set correctly to our proxy

    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi

    service squid restart
    systemctl enable squid
    if [ $? = 0 ] ; then
		echo "======================================"
		echo "SERVICE SQUID-PROXY FONCTIONNEL"
		echo "======================================"
	fi

    # This part of the code adds a proxy user with multiple error detections

    while true; do

	read -p "Voulez vous ajoutez un utilisateur proxy ? (O/n)" yn

	case $yn in 
		[oO] ) echo "Ajout dutlisateur:";
			break;;
		[nN] ) echo "Configuration squid termine.";
			return 1;;
		* ) echo "Reponse invalide";;
	esac

	done

	if [ ! -f /usr/bin/htpasswd ]; then
	    echo "htpasswd nexiste pas"
	    return 1
	fi

	read -p "Entrer votre nom dutilsateur squid proxy " proxy_username

	if [ -f /etc/squid/passwd ]; then
	    /usr/bin/htpasswd /etc/squid/passwd $proxy_username
	else
	    /usr/bin/htpasswd -c /etc/squid/passwd $proxy_username
	fi

	service squid restart
	if [ $? = 0 ] ; then
		echo "======================================"
		echo "SERVICE SQUID-PROXY FONCTIONNEL"
		echo "======================================"
	fi
	'
}

# main

testScp $HOSTNAME
testSshfs $HOSTNAME
testNfs $HOSTNAME
testFtp $HOSTNAME
testApache2 $HOSTNAME
testSquid $HOSTNAME