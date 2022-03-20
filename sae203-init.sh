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

baseConfig() {
	echo "baseConfig $@..."
 
	# Gives the current machine its correct name and
	# matches the IP <-> nom  in (/etc/hosts)
	vdn-ssh root@$1 '
		# fixe le nom de la machine (/etc/hostname)
		echo '$1' > /etc/hostname
		hostname -F /etc/hostname
 
		#  matches the IP <-> nom  in (/etc/hosts)
 
		if ! grep -q '$2' /etc/hosts; then
			echo '$2 $1' >> /etc/hosts
		fi
		'
}
 
testBaseConfig() {
 
	echo "testBaseConfig $@..."
	vdn-ssh test@$1 '
		if [ $(hostname) != "'$1'" ]; then
			echo "ERROR : Nom hôte invalide !" >&2
			exit 1
		fi
 
		if ! ping -c 1 '$1' &> /dev/null; then
			echo "ERROR : Impossible de joindre '$1' !" >&2
			exit 1
		fi
	'
} #Tests if the machines name is correct and if our loopback works

password(){
	echo "====================================================="
	#Changes the password for both root and test
	echo "Changement du mot de passe pour root"
	vdn-ssh root@$1 ' #Changes password for root
		passwd'
	echo "------------------------------------------------------"
	echo "Changement du mot de passe pour test"
	vdn-ssh test@$1 ' #Changes password for test
		passwd'
}

ssh() {
	echo "====================================================="
	#the following code checks for the presence of authorized_keys file in root and test,
	#if its not found we create the directory .ssh and the file authorized_keys for both root and test
	echo "Verification de la presence de ssh/authorized_keys pour root"
	vdn-ssh root@$1 'if [ -f ~/.ssh/authorized_keys ] ; then
						echo "fichier ~/.ssh/authorized_keys déja present pour root"
					else
						echo "Creation du fichier authorized_keys ssh pour root"
						mkdir ~/.ssh ; cd ~/.ssh ; touch authorized_keys
					fi'
	echo "------------------------------------------------------"
	echo "Verification de la presence de ssh/authorized_keys pour test"
	vdn-ssh test@$1 'if [ -f ~/.ssh/authorized_keys ] ; then
						echo "fichier ~/.ssh/authorized_keys déja present pour test"
					else
						echo "Creation du fichier authorized_keys ssh pour test"
						mkdir ~/.ssh ; cd ~/.ssh ; touch authorized_keys
					fi'

	echo "====================================================="
	#The following code puts the local machines public ssh key in root and test
	echo "Transfere de clé ssh vers root@$1 ..."
	vdn-ssh root@$1 'cat > ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
	echo "------------------------------------------------------"
	echo "Transfere de clé ssh vers test@$1 ..."
	vdn-ssh test@$1 'cat > ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub 
}

# main
while true; do

read -p "Votre machine va s'éteindre lors de la fin du processus d'installation, voulez vous continuez? (O/n)" yn

case $yn in 
	[oO] ) echo "sae203-init.sh ...";
		break;;
	[nN] ) echo "Au revoir...";
		exit;;
	* ) echo "Reponse invalide";;
esac

done
baseConfig $HOSTNAME
testBaseConfig $HOSTNAME
password $HOSTNAME
ssh $HOSTNAME

vdn-halt $HOSTNAME
