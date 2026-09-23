# SEO Blueprint

Une étude SEO complète, lancée depuis Claude Code en une commande. Elle part de
**ton** activité, pas d'une liste de mots-clés générique.

C'est la méthode qu'on a appliquée chez [Scalon](https://scalon.fr) : site
ouvert à Google le 26 août 2026, zéro lien entrant, cité dans l'Aperçu IA de
Google dès le lendemain, et une étude de mots-clés complète pour 1,28 $.

👉 **[Prendre 30 minutes avec Valentin](https://cal.com/valentin-morterol-ezc5qn/30min)**

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/morterolvalentin-ctrl/seo-blueprint/main/install.sh | bash
```

Puis, dans Claude Code :

```
/seo-audit
```

<br>

> Tu préfères voir ce que fait le script avant de le lancer ?
> [`install.sh`](install.sh) clone ce dépôt dans un dossier temporaire, copie
> la skill dans `~/.claude/skills/seo-audit/` (en sauvegardant une version
> existante), et dépose le script d'audit et trois fiches dans
> `~/.claude/seo-blueprint/`. Il ne touche à rien d'autre et n'installe aucune clé.

## Deux chemins

La skill commence par une question : **as-tu déjà un site ?**

| | A. J'ai un site | B. Pas encore de site |
|---|---|---|
| **Point de départ** | Ton URL | Ce que tu vends, à qui, dans quel pays |
| **Audit technique** | Gratuit, automatique : indexation, doublons d'adresse, sitemap, llms.txt, fil d'Ariane, copies markdown, titles, PageSpeed Insights | Remplacé par la checklist du socle à poser dès le premier jour |
| **Ton activité** | Reformulée à partir du site, tu valides | Reformulée à partir de tes réponses, tu valides |
| **Données réelles** | Ta Search Console (gratuit via OpenSEO) | |
| **Recherche de requêtes** | OpenSEO | OpenSEO |
| **Rapport** | Tableaux : territoires, requêtes, difficulté, CPC, plan de pages, corrections techniques | Pareil, plus la difficulté de ton marché avant d'y investir |

## Les étapes

| Phase | Ce qu'il se passe | Tu fais quoi |
|---|---|---|
| **0. Aiguillage** | Site ou pas de site | Tu choisis |
| **1-2. Audit technique** (A) | Le script vérifie ton site, sans compte ni crédit | Rien, ou tu crées une clé PageSpeed gratuite si l'API est saturée |
| **3. Ton activité** | Elle reformule ce que tu vends, à qui, et te demande qui sont vraiment tes clients et ton besoin du moment | Tu corriges et tu valides |
| **3 bis. Le rapport technique** (A) | À corriger (P0, P1, P2), à vérifier à la main, ce qui est déjà bon | Tu lis |
| **4. OpenSEO** | Elle te donne la commande de connexion, et la marche à suivre pour la Search Console | Tu te connectes |
| **5. Le plan de dépense** | Elle lit la Search Console (gratuit), puis t'annonce chaque appel payant, en crédits | Tu valides le budget |
| **6. La recherche** | Tes termes, les requêtes voisines, tes concurrents, les résultats Google réels | Rien |
| **7. Le rapport** | Un fichier markdown avec les tableaux et le plan des 30 prochains jours | Tu lis, tu produis |

## Ce que ça coûte

| Outil | Rôle | Coût |
|---|---|---|
| [Claude Code](https://claude.com/claude-code) | Pilote l'ensemble | ton abonnement |
| [OpenSEO](https://openseo.so) | Volume, difficulté, CPC, qui ranke sur quoi | essai 0,50 $, puis 10 $ par mois qui incluent 10 $ d'usage |
| Google Search Console | Tes requêtes et positions réelles | 0 € |
| PageSpeed Insights | La vitesse et la qualité technique | 0 € |

Notre étude complète (1 275 requêtes testées, 8 concurrents, 29 pages de
résultats) a coûté 1,28 $ de données. La skill lit le coût de chaque outil avant
de s'en servir, choisit la combinaison la moins chère, et t'annonce chaque
dépense avant de la faire.

## Ce qu'il y a dans ce dépôt

| Fichier | Rôle |
|---|---|
| [`skills/seo-audit/SKILL.md`](skills/seo-audit/SKILL.md) | La skill |
| [`scripts/audit-technique.sh`](scripts/audit-technique.sh) | L'audit technique, utilisable seul : `bash scripts/audit-technique.sh https://ton-site.fr` |
| [`references/checklist-technique.md`](references/checklist-technique.md) | La grille de lecture de l'audit, avec les priorités et le pourquoi de chaque point |
| [`references/openseo.md`](references/openseo.md) | Connexion, prix, coût de chaque outil et l'ordre d'appel le moins cher |
| [`references/modele-rapport.md`](references/modele-rapport.md) | La structure du rapport final |

## Ce que la skill ne fait pas

Elle ne publie rien, ne modifie pas ton site sans demande, n'achète pas de
liens. Elle ne traite pas le SEO local d'une boutique qui cherche ses clients
du quartier : c'est un autre métier.

## Licence

MIT. Prends, adapte, redistribue.
