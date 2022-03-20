## TP PiHole
Avant de commencer le TP assurez-vous de bien avoir installer et configurer votre PiHole grâce aux scripts `sae203-install.sh`
et `sae203-services .sh`.

### Bloquer les publicités

> Pour acceder a l'interface PiHole veuillez utiliser l'adresse et le mot de passe fournie lors de l'installation.
> 
> Pour changer le server DNS, veuillez accéder a la section  **Settings > DNS**
>
> Ajout d'un lien a la liste noir:
> > Accéder à **Group Management > Adlist** depuis l'interface web.
> > 
> > Ajouter votre lien/domaine fournisseur de publicité dans la section `List of configured adlists`
>
> Autoriser un domaine:
> > Accéder à **Whitelist** depuis l'interface web et ajouter votre domaine.

- Vous allez devoir bloquer toutes les publicités d'amazon, voici leur lien fournisseurs de pubs `https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt`.

- Ajouter le domaine google a votre whitelist afin d'éviter des problemes de connexion avec google maps, liens `clients4.google.com `, `clients2.google.com`.
