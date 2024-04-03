# Rapport CSI2532 groupe 42

## SGBD et langages de programmation

SGBD: PostgreSQL

Langages de programmation: JavaScript, HTML, CSS

## Étapes d'installation
Pour faire fonctionner l’application, voici la procédure:

1. Téléchargez le dossier website et ouvrez un command prompt dans ce dossier.

2. Dans server.js, modifiez les variables dans pool. Donc, le username, password, et le nom de la base de données.

3. Vous aurez besoin de [Node.js](https://nodejs.org/en/download) ainsi que de certains package, installez comme suit:

```bash
npm install express cors pg body-parser
```

4. Dans le command prompt, faites:

```bash
node server.js
```

5. Assurez-vous que la base de données est active.

6. Avec un serveur local, ouvrez index.html. J'ai testé avec [live server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) pour VsCode et live-server de npm que vous pouvez installer comme suit:

```bash
npm install -g live-server
```

et ensuite passez cette commande pour lancer le serveur:

```bash
live-server
```

7. Le site web devrait maintenant être opérationnel.

## DDLs

Premièrement, nous avons la table address. Ensuite, puisque client et employé partagent plusieurs attributs, nous avons la table personne. Chaque personne a également une addresse.

Ensuite, nous créons les tables chaine et hotel, où chaque hotel appartient à une chaîne.

Par après, la table role est créée et ensuite employé. Role est créé en premier pusique chaque employé a besoin d'un role.

De même pour les tables comodite, problem et chambre, puisque chambre a un attribut dépendant de ces deux autres tables.

Nous créons ensuite client. Client aurait pu être défini plus tôt puisque cette table ne dépend que de personne.

Et finalement, nous avons reservation et check_in qui doivent être créés derniers puisque reservation requiers un client et une chambre, alors que check_in requiers une réservation et un employé.

Nous avons aussi trois index qui peuvent être utilisés pour accélérer certaines recherches. Nos index sont utiles du point de vue employé. Ils peuvent facilement trouver quelles chambres sont réservées par qui en faisant une recherche par nas du client, ce qui permet ensuite de voir les réservations associées à ce client.
De plus, nous avons un index permettant de voir les réservations par date, ce qui permet aux employés de donner des suggestions de chambre rapidement aux clients qui se présentent sans réservation.
Finalement, nous avons un index pour rechercher les informations d'un hotel spécifique, ce qui permet aux employés de voir quelles chambres sont encore disponibles dans cet hotel.
