## TP Squid-Proxy
Avant d'attaquer le TP assurez-vous de bien avoir installer et configurer votre proxy grâce aux scripts `sae203-install.sh`
et `sae203-services .sh`.

### Bloquer l'acces a un site web
> La ligne `acl RestrictedSites https:web ` permet de bloquer l'access a un site web.
> Le fichier de configuration squid proxy est `/etc/squid/squid.conf`.

Pour ce TP, Vous allez devoir bloquer l'accer au site web ` https://www.impots.gouv.fr/`.

### Reistreindre l'acces a un site web
> La ligne `acl official_hours time X HH:MM-HH:MM` permets de specifier les heures ou autoriser ou interdire l'accès à internet ou à certains sites web.
> - `X` represente la premiere lettre du jour en anglais. 
> - `HH:MM-HH:MM` represente les horaires. 
> - - Par exemple : `acl official_hours time M T 09:00-18:00` définit la période suivant : Le lundi (M) et le Mardi (T) de 9h a 18h
 >
>`http_access deny official_hours` Interdit l'acces aux heures définit.
>
>`http_access allow official_hours` Autorise l'access aux heures définit.

 Vous allez devoir bloquer l'accer au site web ` https://www.impots.gouv.fr/` pour les 10 prochaines minutes qui suivent.
