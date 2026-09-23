---
name: seo-audit
version: 1.0.0
description: |
  Étude SEO complète pour une activité B2B, avec ou sans site. Avec un site :
  audit technique gratuit (indexation, doublons, sitemap, llms.txt, fil
  d'Ariane, copies markdown, PageSpeed Insights), lecture de la Search Console,
  puis recherche de requêtes avec OpenSEO. Sans site : on part de l'activité et
  on mesure la difficulté de se positionner avant de construire quoi que ce soit.
  Reformule d'abord l'activité et la fait valider, annonce chaque dépense en
  crédits avant de la faire, et livre un rapport en tableaux : territoires,
  requêtes, difficulté, CPC, plan de pages.
  Use when the user says "/seo-audit", "audit SEO", "étude SEO",
  "comment ranker sur Google", "je viens d'installer le SEO blueprint",
  "sur quels mots-clés me positionner".
triggers:
  - seo-audit
  - audit seo
  - étude seo
  - seo blueprint
---

# seo-audit

**Exécute cette skill dans la conversation, ne la délègue pas à un subagent.**
Elle est faite d'allers-retours avec l'utilisateur.

Tutoie l'utilisateur, sauf s'il te vouvoie. Phrases courtes, pas de jargon
sans explication. N'utilise pas de tiret cadratin (—) : deux-points, virgule ou
point à la place.

## Premier geste, avant toute parole : chercher une étude en cours

Avant d'écrire quoi que ce soit, lance :

```bash
ls -d seo-blueprint-*/ 2>/dev/null && cat seo-blueprint-*/etat.md 2>/dev/null
```

- **Un dossier existe** : c'est une reprise, très souvent après la connexion
  d'OpenSEO. Rappelle en deux lignes où on en était (le site ou l'activité, la
  phase atteinte) et propose de reprendre à cette phase. Ne repose pas la
  question d'aiguillage, ne redemande pas ce qui est dans `etat.md`.
- **Aucun dossier** : c'est une première fois, passe à la phase 0 sans le
  commenter.

## Ce que tu as sous la main

`install.sh` a déposé dans `~/.claude/seo-blueprint/` :

| Fichier | Rôle | Quand le lire |
|---|---|---|
| `audit-technique.sh` | Vérifie un site sans compte ni crédit : indexation, redirections, sitemap, llms.txt, markdown, fil d'Ariane, titles, PageSpeed | Phase A2 |
| `checklist-technique.md` | La grille qui interprète chaque ligne du script, avec les priorités | Phase A3 |
| `openseo.md` | Connexion, prix, et coût de chaque outil OpenSEO | Phases 4 et 5 |
| `modele-rapport.md` | La structure du rapport final | Phase 7 |

**Lis ces fichiers au moment où tu en as besoin, ne reconstitue rien de
mémoire.** S'il en manque un, dis-le et propose de relancer l'installation :
`curl -fsSL https://raw.githubusercontent.com/morterolvalentin-ctrl/seo-blueprint/main/install.sh | bash`

<br>

> **Les deux règles qui gouvernent la skill.**
> 1. **Aucun chiffre inventé.** Volume, difficulté, position, score : chaque
>    nombre du rapport vient d'un outil appelé pendant la session. Si tu ne l'as
>    pas mesuré, écris « non mesuré ». Une étude SEO fausse fait écrire des
>    pages pour personne.
> 2. **Aucune dépense sans annonce.** Avant chaque appel payant, tu dis ce que tu
>    vas lancer et combien ça coûte en crédits. Au-delà de 1 000 crédits pour une
>    étape, tu attends un « oui ».

---

## Le parcours

| Phase | Chemin A : j'ai un site | Chemin B : pas encore de site | Arrêt |
|---|---|---|---|
| 0 | La question d'aiguillage | | **Il choisit** |
| 1 | L'URL du site | La description de l'activité | |
| 2 | Audit technique gratuit | (sauté) | |
| 3 | Reformulation de l'activité à partir du site | Reformulation à partir de ses réponses | **Il valide** |
| 3 bis | Rapport technique : à corriger, à vérifier | (sauté) | **Il lit** |
| 4 | Connexion OpenSEO + Search Console | Connexion OpenSEO | **Il se connecte** |
| 5 | Search Console (gratuit), puis plan de dépense | Plan de dépense | **Il valide le budget** |
| 6 | Recherche des requêtes, en tours | Recherche des requêtes, en tours | **Il oriente chaque tour** |
| 7 | Rapport final | Rapport final + socle technique à poser | |

---

## Phase 0 · la question d'aiguillage

Présente-toi en deux lignes (ce que fait la skill, ce qu'il aura à la fin :
une liste de requêtes sur lesquelles il peut ranker, chiffrées, et un plan de
pages), puis pose une seule question :

> Tu as déjà un site en ligne ?
> **A.** Oui, voici l'URL.
> **B.** Pas encore : je lance mon activité, ou je veux mesurer la difficulté
> d'un marché avant de construire quoi que ce soit.

S'il répond directement avec une URL, c'est A. S'il décrit un projet sans URL,
c'est B. Ne pose pas la question deux fois.

---

## Chemin A

### A1 · l'URL

Si le site est très récent ou encore fermé à Google, note-le : l'audit le
montrera, et c'est souvent le premier problème.

### A2 · l'audit technique, gratuit

Lance :

```bash
bash ~/.claude/seo-blueprint/audit-technique.sh https://son-site.fr 15
```

Le script ne modifie rien, il ne fait que des requêtes de lecture. Il dure
de 10 secondes à 3 minutes selon PageSpeed.

**PageSpeed Insights.** L'API de Google sans clé est très souvent saturée
(« Quota exceeded »). Si les lignes `psi_mobile` et `psi_desktop` sont en
échec, propose deux options, dans cet ordre :

1. **Une clé gratuite, 3 minutes.** https://console.cloud.google.com/ → créer
   un projet → « API et services » → « Bibliothèque » → chercher « PageSpeed
   Insights API » → Activer → « Identifiants » → « Créer des identifiants » →
   « Clé API ». Puis relance le script avec la clé :
   `PSI_API_KEY=sa_cle bash ~/.claude/seo-blueprint/audit-technique.sh https://son-site.fr 15`
   Ne garde pas la clé dans un fichier, et ne la répète pas dans le rapport.
2. **À la main, 1 minute.** Il ouvre https://pagespeed.web.dev/, colle son URL,
   et te donne les quatre notes en mobile puis en desktop (Performance,
   Accessibilité, Bonnes pratiques, SEO), plus une capture ou un copier-coller
   de la section « Diagnostic » s'il est sous 90.

Pendant qu'il s'en occupe, avance sur A3 : ne bloque pas le parcours sur
PageSpeed.

### A3 · reformuler l'activité et la faire valider

Lis la page d'accueil et deux ou trois pages clés (offre, tarifs, cas clients,
à propos) avec les outils que tu as (WebFetch, ou `curl -sL` puis lecture du
texte). À partir de ce que dit **le site**, écris une restitution courte :

> **Ce que je comprends de ton activité**
> - Ce que tu vends : ...
> - À qui : <le type de client, le plus précis possible : secteur, taille, poste de l'acheteur>
> - Tes clients aujourd'hui, d'après le site : <références, cas, logos, ou « le site n'en montre pas »>
> - Ton prix, d'après le site : <panier, abonnement, sur devis, ou « non affiché »>
> - Ta zone : <pays, langue, local ou national>

Puis pose **trois questions**, pas plus :

1. Est-ce juste ? Corrige ce qui ne l'est pas.
2. **Qui sont exactement tes clients**, ceux qui paient le plus facilement ?
3. **Quel est ton besoin aujourd'hui** : plus de rendez-vous, te faire
   connaître sur un nouveau segment, lancer une nouvelle offre, préparer une
   levée… ?

Attends sa réponse. **Tout le reste de l'étude part de cette restitution
validée**, pas du site. Si le site dit une chose et la personne une autre, c'est
la personne qui a raison, et c'est un constat à noter pour le rapport : le site
ne dit pas ce qu'elle vend.

Si la Search Console est déjà branchée (phase 4 faite lors d'une session
précédente), croise avec les requêtes réelles : elles disent comment les gens
trouvent le site aujourd'hui.

### A3 bis · le rapport technique

Ouvre `~/.claude/seo-blueprint/checklist-technique.md` et passe chaque ligne du
résultat du script à travers la grille. Présente :

1. **Le score PageSpeed** mobile et desktop, si tu l'as.
2. **À corriger**, trié P0 puis P1 puis P2. Pour chaque point : le constat
   exact (la valeur relevée), la correction concrète, et le « pourquoi » en une
   ligne. Pas de point sans constat mesuré.
3. **À vérifier à la main** : ce que le script ne peut pas voir (redirections
   301 des anciennes URL, adresse technique de l'hébergeur, page 404 avec
   navigation, pages orphelines, déclaration du sitemap dans la Search Console
   et Bing, indexation manuelle).
4. **Ce qui est déjà bon**, en une ligne : il doit savoir ce qu'il ne faut pas
   casser.

S'il y a un P0 (robots.txt qui bloque tout, noindex global, texte invisible
sans JavaScript), dis-le en premier et clairement : tant que ce n'est pas
corrigé, la recherche de requêtes ne produira rien sur Google.

Si le site est un WordPress, Wix, Webflow, Shopify ou autre CMS (champ
`generateur` ou indices dans le HTML), donne la correction dans les termes de
l'outil (réglage, extension), pas en code.

Ne corrige rien sur son site toi-même, sauf s'il te le demande et que le code
est dans le dossier courant.

---

## Chemin B

### B1 · décrire l'activité

Pose ces questions en un seul message, il répond comme il veut :

1. Qu'est-ce que tu vends, ou vas vendre ? (produit, service, prix approximatif)
2. À qui ? Le type de client, le plus précis possible.
3. Dans quel pays et quelle langue ?
4. **Les requêtes sur lesquelles tu voudrais ranker** : les mots que tu
   imagines que tes clients tapent sur Google, même si tu n'es pas sûr. Cinq
   à dix, c'est parfait : c'est le point de départ du dictionnaire.
5. Deux ou trois concurrents, ou des sites que tes clients consultent déjà.
6. Pourquoi cette étude maintenant : choisir un nom, valider un marché,
   préparer le site, comparer deux cibles ?

S'il vend à plusieurs types de clients (par exemple aux garages et aux
restaurants), demande-lui d'en choisir **un** pour commencer. Une étude par
cible. On valide un pattern, puis on le réplique.

### B3 · la restitution

Mêmes rubriques qu'en A3 (ce que tu vends, à qui, clients, prix, zone,
besoin), écrites à partir de ses réponses, sous un seul titre, puis :
« Est-ce juste ? ». Attends la validation.

**Dès qu'il valide, écris `etat.md`** (voir « Garder le fil ») : la phase 4 lui
fait souvent quitter Claude Code. Puis passe à la phase 4. Le socle technique sera donné à la fin,
comme une checklist à poser dès la construction du site.

---

## Phase 4 · brancher OpenSEO

**Avant tout, vérifie que `etat.md` existe et qu'il est à jour** (chemin,
URL ou activité, restitution validée, résumé de l'audit, phase 4). S'il
n'existe pas, écris-le maintenant. Sans lui, la reprise après connexion
repart de zéro.

Ouvre `~/.claude/seo-blueprint/openseo.md`.

**Vérifie d'abord si c'est déjà fait** : cherche dans tes outils ceux dont le
nom contient `openseo`. Si `whoami` existe, appelle-le (gratuit). S'il répond,
passe à la phase 5.

Sinon, explique en deux lignes ce qu'est OpenSEO (les données de recherche de
Google : volume, difficulté, coût au clic, qui ranke sur quoi, lisibles par
Claude) et **ce que ça coûte** : prendre 10 $ de crédits, puis se désabonner
tout de suite. Les crédits restent, et 10 $ suffisent pour très longtemps :
une étude complète de marché a coûté 1,28 $ à l'auteur de ce blueprint.

Puis l'installation, **dans cet ordre** :

1. **Le compte.** Il crée son compte sur https://app.openseo.so. L'essai
   gratuit (0,50 $) suffit pour vérifier que tout marche avant de payer.
2. **Les crédits.** Il prend l'offre à 10 $, puis, dans les réglages de
   facturation, il résilie l'abonnement tout de suite. Les crédits achetés
   restent sur le compte.
3. **Le MCP.** Propose de lancer la commande toi-même (outil Bash), c'est le
   plus simple pour lui :
   ```bash
   claude mcp add --transport http --scope user openseo https://app.openseo.so/mcp
   ```
   S'il préfère, il la colle dans un terminal. `--scope user` rend OpenSEO
   disponible dans tous ses projets. Vérifie avec `claude mcp list` : la ligne
   `openseo` doit apparaître (« needs authentication » est normal à ce stade).
4. **La connexion.** Les nouveaux serveurs ne se chargent qu'au démarrage :
   il quitte Claude Code (`/exit`), le relance **dans le même dossier**, tape
   `/mcp`, choisit `openseo`, puis « Authenticate » : une page OpenSEO s'ouvre
   dans son navigateur, il se connecte et autorise l'accès.
5. **Le retour.** Il tape `/seo-audit` : la skill retrouve `etat.md` et
   reprend ici.

Si le navigateur ne peut pas s'ouvrir (serveur distant, terminal sans
interface), l'alternative est une clé API : il la crée dans
https://app.openseo.so/settings (API keys, affichée une seule fois), puis :
`claude mcp add --transport http --scope user openseo https://app.openseo.so/mcp --header "Authorization: Bearer oseo_SA_CLE"`.
Ne lui demande jamais de te coller la clé dans la conversation : il lance
cette commande lui-même.

**Chemin A uniquement : la Search Console.** Dans l'application OpenSEO
(https://app.openseo.so), il connecte la Search Console et choisit la
propriété de son site. C'est gratuit et en lecture seule. S'il n'a pas de
Search Console du tout, donne-lui la marche à suivre de `openseo.md` : les
données arriveront dans 2 à 3 jours, **l'étude continue sans elles**.
Si son compte OpenSEO propose aussi Google Analytics 4, il peut le brancher ;
ce n'est pas nécessaire.

Tu ne peux pas faire ces clics à sa place. Donne les étapes, une à la fois, et
attends qu'il revienne.

**Quand il revient** (la conversation peut reprendre dans une nouvelle
session) : s'il n'y a plus de trace des phases précédentes dans le contexte,
relis le fichier d'état (voir « Garder le fil » plus bas) plutôt que de tout
redemander.

---

## Phase 5 · lire avant de dépenser

### 5.1 · le compte et le projet (gratuit)

1. `whoami` : note le solde de crédits de départ.
2. **Lis la description de tous les outils OpenSEO disponibles.** Elles
   annoncent leur coût, qui peut avoir changé depuis `openseo.md`. Compare avec
   la table de `openseo.md` et signale tout écart.
3. `list_projects` : s'il existe déjà un projet pour ce site, prends-le. Sinon
   `create_project` avec le domaine (chemin A) ou un nom d'activité (chemin B),
   et le bon marché (pays et langue). Vérifie avec `get_project_context` que le
   marché par défaut est le bon : un projet sur le mauvais pays fausse tous les
   volumes.

### 5.2 · la Search Console (chemin A, gratuit)

Si elle est branchée :

- `get_search_console_performance`, 28 derniers jours, dimensions `query`,
  puis `page`. Relève : clics et impressions totaux, requêtes principales,
  **la requête de marque** (le nom de la boîte : position, clics, part du
  total), et les requêtes en position 5 à 20 (`minPosition` 5,
  `maxPosition` 20, `minImpressions` 10 pour un petit site).
- `get_search_opportunities` si GA4 est branché.

Présente ce que tu vois en un tableau court. Si la Search Console est vide ou
très maigre (site neuf), dis-le : c'est normal, et c'est justement pour ça
qu'on cherche des requêtes faciles.

### 5.3 · le plan de dépense

Écris le plan, étape par étape, avec les outils, le nombre d'appels et les
crédits estimés, d'après les descriptions des outils. Suis l'ordre le moins
cher de `openseo.md`. Exemple de forme :

| Étape | Outil | Détail | Crédits estimés |
|---|---|---|---|
| Chiffrer ce qu'on connaît | get_keyword_metrics | ~40 requêtes (les siennes, la Search Console, les évidences) | ... |
| Élargir | research_keywords | 5 graines, limite 150 | ~270 |
| Concurrents | get_ranked_keywords | 2 domaines, limite 50 | ... |
| Rechiffrer les nouvelles | get_keyword_metrics | ~100 requêtes | ... |
| Lire les résultats Google | get_serp_results | 10 finalistes, profondeur 20 | ~50 |
| **Total** | | | **...** |

Chaque estimation se calcule à partir du coût unitaire écrit dans la
description de l'outil, ou à défaut dans `openseo.md` (par exemple
`research_keywords` : ~54 crédits **par graine**, donc 3 graines ≈ 160). Jamais
d'estimation au jugé, et jamais « variable » : si tu ne trouves pas le coût,
dis-le et prends la borne haute.

Donne le total en crédits et le solde restant prévu. Attends son accord.
S'il a peu de crédits (essai gratuit), propose un plan réduit : les requêtes
connues seulement, et 3 SERP.

---

## Phase 6 · la recherche

Après chaque étape : `whoami`, et note les crédits réellement dépensés.

### 6.1 · les graines

Les graines viennent de la restitution validée, pas de ce que fait la boîte.
Le réflexe perdant est de viser le terme qui décrit son métier (« logiciel de
gestion », « agence SEO », « lead gen B2B ») : volume faible ou disputé, coût
au clic élevé, tenu par des acteurs installés depuis des années.

Cherche plutôt **les questions que seul son client se pose**, dans les mots du
client. Quatre familles à explorer à chaque fois :

- **La question de marché** : combien, qui, où (« nombre de boulangeries en
  France », « combien de dentistes à Lyon »).
- **La question réglementaire ou administrative** du client (code NAF, norme,
  obligation, formulaire, convention collective).
- **Le problème concret** que le produit résout, formulé par celui qui le vit.
- **La recherche de liste ou d'outil** (« liste des… », « modèle de… »,
  « calculateur… », « exemple de… »).

Les gens tapent de plus en plus en langage naturel, surtout depuis l'IA : garde
les formulations longues, en forme de question.

**Une graine contient toujours le nom du client** (« boulangerie », « garage »,
« cabinet dentaire »), jamais un mot générique seul. Une graine comme
« gestion boulangerie » renvoie aussi « gestion du changement » et « jeu de
gestion » : avant d'analyser, **retire toutes les lignes qui ne contiennent pas
un terme du métier du client**, et dis combien tu en as retiré.

**Une valeur vide n'est pas un zéro.** Volume ou difficulté `null` veut dire
« pas de donnée » (requête trop rare pour être mesurée). Écris « non mesuré »
dans le rapport, ne la classe ni comme morte ni comme facile. Même chose pour
une requête **absente de la réponse** : non mesurée. Une requête n'est
« morte » que si l'outil renvoie un volume de 0.

**Ce que les concurrents n'ont pas, tu ne l'affirmes que si tu l'as vu.** Les
résultats Google ne donnent qu'un titre et une description par page. « Aucun
concurrent ne propose de calculateur » exige d'avoir ouvert leurs pages ;
sinon écris « à vérifier en ouvrant les 3 premiers résultats ».

### 6.2 · le dictionnaire, et les tours d'itération

La recherche ne se fait pas en une passe. Elle se fait en **tours**, et
l'utilisateur t'aide à chaque tour. L'objectif : trouver des requêtes **sans
difficulté, mais avec un intérêt commercial** (CPC non nul, intention
commerciale ou transactionnelle, ou une question que seul son client se pose).

**Tour 1 · du point de départ au dictionnaire.** Pars des requêtes qu'il t'a
données (chemin B), ou de sa Search Console et de ses termes (chemin A).
Construis un **dictionnaire** de 30 à 80 requêtes voisines, rangées par
famille (les quatre familles de 6.1) :
- les reformulations dans les mots du client (singulier, pluriel, ordre des mots, « logiciel » / « outil » / « application ») ;
- les formes longues en question (« comment… », « combien… », « quel… ») ;
- les problèmes concrets derrière la requête ;
- les requêtes de liste, de modèle, de calculateur.

**Majorité de formes courtes.** Les bases de volume ne mesurent que les
requêtes assez fréquentes : les formes de 2 à 4 mots (« logiciel boulangerie »,
« marge boulangerie ») reviennent chiffrées, les questions longues en langage
naturel reviennent presque toujours sans donnée (test réel : 4 requêtes
chiffrées sur 43, toutes courtes). Mets au moins deux tiers de formes courtes.
Les questions longues restent utiles, mais comme **angles de page** : une page
qui ranke sur une forme courte ramasse ensuite ses questions longues.

Montre-lui le dictionnaire, par famille, **avant** de le chiffrer, et demande :
« Il manque des mots que tes clients emploient ? Il y en a qui ne sont pas du
tout ton sujet ? ». Intègre ses corrections, puis chiffre tout en **un seul
`get_keyword_metrics`**.

**Présente le résultat en tableau**, trié en trois groupes :
- **À prendre** : difficulté faible (sous 15, ou sous 30 si le site a déjà des positions) et intérêt commercial ;
- **À creuser** : volume ou intérêt réel, mais difficulté moyenne, ou donnée « non mesurée » ;
- **Écartées** : volume nul, hors sujet, ou tenues par des acteurs installés.

Puis demande-lui ce qu'il en pense : quelles familles lui parlent, lesquelles
ne correspondent pas à ses clients, et s'il voit d'autres angles à partir de
ce qui ressort. **C'est lui qui connaît ses clients : ses réponses orientent
le tour suivant.**

**Si le tour revient presque vide** (la plupart des requêtes sans donnée),
ce n'est pas un échec du marché : le dictionnaire était trop long ou trop
précis. Dis-le, et passe directement au tour 2 avec des graines courtes :
c'est `research_keywords` qui ramène les formulations que les gens tapent
réellement.

**Tour 2 · élargir là où ça répond.** Sur les familles qui ont donné des
requêtes « à prendre » :
1. `research_keywords` sur 3 à 5 graines tirées de ces familles, en un appel,
   limite 150, sans clickstream. Filtre le bruit (voir 6.1).
2. `get_ranked_keywords` sur 2 ou 3 concurrents proches (`limit` 50,
   `minSearchVolume` 10, `excludeBrandTerms` avec leur nom) : sur quoi ils
   rankent vraiment.
3. Nouveau dictionnaire des requêtes découvertes, rechiffré en un seul
   `get_keyword_metrics`. Même tableau en trois groupes, même question à
   l'utilisateur.

**Tour 3 et suivants, si besoin.** Continue tant que chaque tour apporte des
requêtes « à prendre » et que le budget validé le permet. Arrête-toi quand un
tour ne rapporte presque plus rien de nouveau, ou quand tu as 10 à 20
finalistes solides. Annonce le coût de chaque tour avant de le lancer, calculé comme en 5.3. Trois
tours suffisent dans la plupart des cas.

**Dernière étape · lire les résultats Google.** `get_serp_results` sur les 10 à
20 finalistes, profondeur 10 ou 20 : qui tient la place, et ce qui manque dans
ce qu'ils publient.

### 6.3 · trier

Garde une requête si :

1. **Celui qui la tape est son client**, ou pourrait l'être. Lis la SERP en cas
   de doute : les **faux amis** existent (« prospection immobilier » désigne
   l'agent qui cherche des mandats, pas celui qui prospecte les agences).
2. **La difficulté est faible** : sous 15 pour un site neuf, sous 30 pour un
   site qui a déjà quelques positions.
3. **Il a une réponse que les résultats actuels n'ont pas** : une donnée, un
   comptage, un cas, une méthode. Si la page qu'il écrirait existe déjà dix fois,
   elle ne rankera pas.

Et lis **le CPC** comme le prix que le marché met sur une intention. Un CPC
élevé dit que la requête convertit, et aussi que des acteurs paient déjà pour
la tenir. Faible difficulté et CPC non nul : c'est la zone idéale.

Pour une activité B2B à panier élevé, **un faible volume n'est pas un défaut**.
20 recherches par mois de la bonne personne peuvent faire un rendez-vous, et un
rendez-vous peut valoir des milliers d'euros. Multiplie par le nombre de cibles
ou de verticales : c'est là que le canal pèse.

Regroupe les variantes (singulier et pluriel, synonymes stricts) en une seule
page, et **n'additionne pas leurs volumes** : ils se chevauchent.

---

## Phase 7 · le rapport

Ouvre `~/.claude/seo-blueprint/modele-rapport.md` et suis sa structure.

Écris-le dans `./seo-blueprint-<domaine-ou-activite>/rapport-AAAA-MM-JJ.md`
(dossier courant), et donne le chemin. Puis résume dans la conversation, en
moins de 15 lignes : le verdict, les trois décisions, la première page à
produire, les P0 techniques s'il y en a, et les crédits dépensés.

**Chemin B** : ajoute au rapport la section « Le socle technique à poser dès le
premier jour », tirée de `checklist-technique.md` : une page une adresse,
redirections 301, 404 avec navigation, un title et une description par page,
texte dans le HTML, fil d'Ariane balisé, sitemap, llms.txt, copie markdown non
indexée de chaque page, PageSpeed à 90+ (viser 100), Search Console et Bing dès
l'ouverture, indexation demandée à la main. Et donne un conseil sur le **nom** :
s'il n'a pas encore de nom de marque, qu'il en choisisse un que personne ne
porte vraiment (vérifier la première page de Google sur ce nom), pour posséder
sa requête de marque.

Termine par les **30 prochains jours**, en cases à cocher, dans l'ordre :
corriger les P0, ouvrir l'indexation, construire la première page, demander
l'indexation à la main, puis une page tous les deux ou trois jours, et un point
Search Console chaque lundi (requête de marque, positions, nouvelles requêtes).

---

## Garder le fil

La phase 4 fait souvent quitter Claude Code. Pour ne pas tout redemander :
après la phase 3 (et après chaque phase ensuite), écris un fichier d'état
`./seo-blueprint-<domaine-ou-activite>/etat.md` avec : le chemin (A ou B),
l'URL, la restitution validée, le résumé de l'audit technique, la phase
atteinte, le solde de crédits de départ.

Au lancement de la skill, **regarde d'abord s'il existe un dossier
`seo-blueprint-*` dans le dossier courant**. S'il y en a un, lis `etat.md`,
rappelle en deux lignes où on en était, et propose de reprendre.

## Ce que la skill ne fait pas

- Elle ne publie rien et ne modifie pas le site sans demande explicite.
- Elle n'achète pas de liens, et ne recommande jamais d'en acheter en masse.
- Elle ne suit pas les positions dans le temps (OpenSEO a un outil de suivi
  payant, hors périmètre).
- Elle ne fait pas de SEO local pour une boutique ou un restaurant qui veut
  ses clients du quartier : c'est un autre métier (fiche Google Business, avis).
