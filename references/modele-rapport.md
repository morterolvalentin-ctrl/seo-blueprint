# Modèle de rapport

Le rapport final que la skill écrit. Markdown, tableaux, chiffres à l'unité,
source de chaque chiffre. Les sections marquées **(chemin A)** n'existent que
si la personne a un site.

Règles d'écriture :
- Chaque chiffre vient d'un outil appelé pendant la session. Jamais d'estimation
  présentée comme une donnée. Si une donnée manque, écrire « non mesuré ».
- Volumes, difficultés et CPC tels que renvoyés, sans arrondi.
- Ne pas additionner des volumes de variantes groupées : ils se chevauchent.
- Une recommandation = une action concrète, pas « améliorer le SEO ».

---

```markdown
# Étude SEO : <nom de l'activité>

<date> · marché <pays, langue> · <n> requêtes chiffrées · coût OpenSEO : <crédits> crédits

## L'activité, telle que validée
- Ce que vous vendez : ...
- À qui : ...
- Vos clients aujourd'hui : ...
- Le besoin du moment : ...

## Le verdict
<3 à 5 phrases. Où est la demande accessible, combien de recherches par mois
au total sur les territoires retenus, et la première page à produire.>

| Territoire | Volume / mois | Difficulté | CPC | Pourquoi |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

**Trois décisions.**
1. ...
2. ...
3. ...

## Ce que dit votre Search Console (chemin A)
<28 derniers jours : clics, impressions, position moyenne du site.>

| Requête | Position moyenne | Clics | Impressions | Lecture |
|---|---|---|---|---|

- Requête de marque : <position, clics, part des clics totaux>.
- Requêtes à portée de main (position 5 à 20) : ...

## L'état technique (chemin A)
PageSpeed : mobile <perf/access/bp/seo>, desktop <...>.

| Priorité | À corriger | Constat | Correction |
|---|---|---|---|
| P0 | ... | ... | ... |
| P1 | ... | ... | ... |

**À vérifier à la main** : <liste des points que le script ne peut pas voir>.

## Les territoires

| Famille | Volume | Verdict | Exemples |
|---|---|---|---|
| ... | ... | **Priorité 1** | ... |
| ... | 0 | **Mort** | ... |

## Les requêtes retenues

| Requête | Volume | Difficulté | CPC | Intention | Qui tient la place | Verdict |
|---|---|---|---|---|---|---|

## Les requêtes écartées, et pourquoi
<Les termes auxquels la personne croyait et qui ne pèsent rien, les faux amis,
les requêtes hors d'atteinte (difficulté, CPC élevé tenu par des gros acteurs).>

| Requête | Volume | Difficulté | CPC | Raison |
|---|---|---|---|---|

## Qui tient ces résultats aujourd'hui
<Les domaines qui reviennent, ce qu'ils publient, et ce qu'aucun ne donne :
c'est la place à prendre.>

## Le plan de pages

| # | Page | Requête cible | La question à laquelle elle répond | L'information que vous seul pouvez donner |
|---|---|---|---|---|

Rythme : une page tous les deux à trois jours, 10 à 15 pages par thématique,
reliées entre elles.

## Les 30 prochains jours
- [ ] ...

## Méthode
Données : OpenSEO (DataForSEO), Search Console, PageSpeed Insights, audit HTML.
Crédits dépensés par étape : ...
```
