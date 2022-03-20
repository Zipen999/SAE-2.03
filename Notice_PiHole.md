# NOTICE D'UTILISATION PIHOLE
Si vous avez réussi à exécuter le script `sae203-install.sh` ,  `sae203-services.sh` sans erreurs, votre PiHole doit être prêt pour l'utilisation.

_La configuration s'effectue à partir de vos choix lors de l'installation mais je vais vous montrer comment configurer PiHole pour une utilisation optimale_
### Installation PiHole:

Répondez Ok aux premieres questions...
![1](https://user-images.githubusercontent.com/78689752/159179310-c9025c1d-da4f-4f00-96d2-ef62286afe2a.png)

Choisissez votre serveur DNS (je vous recommande d'utiliser OpenDNS ou google)
![2](https://user-images.githubusercontent.com/78689752/159179502-e4b7765f-d1f1-4bef-942f-ee9d0c7378df.png)

Continuez le processus d’installation avec les options souhaitées jusqu'à atteindre la dernière page ci-dessous ou vous retrouvez les informations de votre PiHole, gardez-les précieusement ils vous seront très utiles pour personnaliser votre PiHole!
![4](https://user-images.githubusercontent.com/78689752/159179730-9a2d47b2-4bcf-4029-9193-dc0543aaadf4.png)

## Bloquer les publicités :
Pour accéder à l'interface web il suffit d'utiliser celle donnée lors de la fin d'installation, le mot de passe est aussi sur cette page la.

Dans la console du Pi-hole, il y a un onglet pour les domaines liste noire, cela montre combien de domaines répertoriés sont là dans cette liste, nous devons mettre à jour cette liste, pour ce faire, nous devons aller à


_**Group Management > Adlist**_


![image](https://user-images.githubusercontent.com/78689752/159183821-f5bf7d08-80f9-498a-a4b5-c7c36f184edb.png)

Et dans la section Adresse, nous pouvons ajouter d’autres sites Web sur liste noire. voici quelques liens qui fonctionnent bien, mais vous pouvez toujours en ajouter de votre côté! :
- https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
- https://mirror1.malwaredomains.com/files/justdomains
- https://easylist-downloads.adblockplus.org/malwaredomains_full.txt
- https://v.firebog.net/hosts/Easylist.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
- https://v.firebog.net/hosts/AdguardDNS.txt
- https://static.doubleclick.net/instream/ad_status.js

Maintenant que la liste est mise à jour, Pi-hole devrait pouvoir bloquer plus d’annonces.

Libre à vous d'explorer toute les options disponible sur PiHole.
