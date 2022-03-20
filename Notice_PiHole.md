# NOTICE D'UTILISATION SQUID
Si vous avez réussi à exécuter le script `sae203-install.sh` et `sae203-services.sh` sans erreurs, votre serveur proxy doit être configuré et prêt pour l'utilisation.

_Vous devez être sur root pour pouvoir correctement configurer votre proxy !_
## Utilisation de Squid 1: Restreindre l’accès à des sites Web spécifiques 
C’est ainsi que vous pouvez empêcher des personnes de naviguer sur certains sites Web lorsqu’ils sont connectés à votre réseau à l’aide de votre serveur proxy.

Créez un fichier appelé `restricted_sites` et répertoriez tous les sites dont vous souhaitez restreindre l’accès.
``` 
$ nano /etc/squid/restricted_sites  
www.youtube.com  
www.facebook.com  
```
lancer la commande si dessous pour terminer la configuration de votre proxy.
```
echo "acl RestrictedSites  dstdomain "/etc/squid/restricted_sites"
http_access deny RestrictedSites" >> /etc/squid/squid.conf
systemctl squid restart
```
## Utilisation de Squid 2: Autoriser l’accès aux sites Web uniquement pendant une période spécifique 
La configuration squid.conf illustrée ci-dessous ne permettra l’accès à Internet pour les utilisateurs qu’entre 9h00 et 18h00 en semaine à vous de le modifier pour configurer vos propres périodes.


les jours sont en anglais: _M = Monday(Lundi), T = Tuesday(Mardi), W = Wednesday(Mercredi), H = Thursday(Jeudi), F = Friday(Vendredi), A = Saturday(Samedi), S = Sunday(Dimanche), D = jours ouvrés._

```
echo "acl official_hours time M T W H F 09:00-18:00
http_access deny all
http_access allow official_hours" >> /etc/squid/squid.conf
systemctl squid restart
``` 
