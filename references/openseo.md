# OpenSEO : connexion et coûts

OpenSEO donne accès aux données de recherche (volume, difficulté, coût au clic,
intention, qui ranke sur quoi) à travers un serveur MCP. Il sert aussi de pont
vers la Search Console, gratuitement.

Site : https://openseo.so · code source : https://github.com/every-app/open-seo (MIT)

---

## Connexion

**Option 1, le serveur MCP seul (recommandée ici).** Dans un terminal :

```bash
claude mcp add --transport http --scope user openseo https://app.openseo.so/mcp
```

Puis relancer Claude Code, taper `/mcp`, choisir `openseo` et se connecter :
la première connexion ouvre la page de login OpenSEO.

**Option 2, avec une clé API** (sans navigateur) : créer la clé dans
https://app.openseo.so/settings (API keys, affichée une seule fois), puis :

```bash
claude mcp add --transport http --scope user openseo https://app.openseo.so/mcp --header "Authorization: Bearer oseo_VOTRE_CLE"
```

## Prix (relevé sur openseo.so/pricing en septembre 2026)

- **Essai gratuit** : 0,50 $ de crédits, sans carte bancaire. Suffisant pour
  vérifier la connexion et lancer deux ou trois appels, pas une étude.
- **Base Plan : 10 $ par mois, qui incluent 10 $ d'usage.** C'est le minimum
  pour une vraie étude. Résiliable, avec 30 jours satisfait ou remboursé selon
  leur page.
- **Recharges** : à tout moment, elles n'expirent pas.
- **La Search Console ne consomme rien.**
- Ordre de grandeur réel : une étude complète d'un marché (1 275 requêtes
  testées, 8 concurrents, 29 pages de résultats) a coûté **1,28 $**. Une étude
  pour une petite activité tient largement dans les 10 $ du mois.

Les coûts sont exprimés en **crédits** dans les outils. `whoami` donne le solde,
gratuitement : c'est la seule mesure fiable de ce qu'une étape a coûté.
**Toujours appeler `whoami` avant et après chaque étape payante.**

## Search Console et Google Analytics

- **Search Console** : se connecte dans l'application OpenSEO (onboarding,
  bouton « Connect Search Console », puis choix de la propriété). Lecture seule,
  gratuite, jusqu'à 16 mois d'historique. Sans Search Console, la skill
  fonctionne, mais sans les données réelles du site.
- **Google Analytics 4** : certains comptes exposent des outils
  `get_google_analytics_*`. S'ils sont présents et répondent, les utiliser (pages
  d'atterrissage organiques, conversions). S'ils ne sont pas là, ne pas insister :
  la Search Console suffit pour cette étude.
- **Le site doit être dans la Search Console avant tout.** Si la personne ne l'a
  jamais fait : https://search.google.com/search-console, ajouter une propriété
  « Domaine », valider par un enregistrement DNS TXT chez son registrar. Les
  données arrivent en 2 à 3 jours : l'étude peut commencer sans attendre.

## Les outils et ce qu'ils coûtent

Les coûts ci-dessous viennent des descriptions des outils en septembre 2026.
**Ils peuvent changer : avant de dépenser, relis la description de chaque outil
que tu comptes utiliser**, elle annonce son coût. C'est le premier réflexe, et
celui qui fait la différence : lire tous les outils, puis choisir la
combinaison la moins chère.

Les noms exacts dépendent de l'installation (`mcp__openseo__research_keywords`,
ou un préfixe de plugin). Cherche les outils dont le nom contient `openseo`.

| Outil | Ce qu'il fait | Coût | Règle d'usage |
|---|---|---|---|
| `whoami` | Compte et solde | **gratuit** | Avant et après chaque étape payante |
| `list_projects`, `create_project`, `get_project_context`, `update_project_context` | Le projet qui porte le domaine et le marché | gratuit | Tous les appels exigent un `projectId`. Un projet par site (ou par activité sans site) |
| `get_search_console_performance` | Requêtes, pages, clics, impressions, position | **gratuit** | Commencer par là quand la Search Console est branchée |
| `get_search_opportunities` | Pages en position 4 à 20 croisées avec GA4 | **gratuit** | Si GA4 est branché |
| `inspect_urls` | Statut d'indexation Google d'une URL | gratuit (Search Console) | Pour vérifier qu'une page importante est indexée |
| `get_keyword_metrics` | Volume, difficulté, CPC, intention, tendance pour **jusqu'à 700 requêtes connues** en un appel | payant | **Le moins cher pour chiffrer une liste.** Tout regrouper en un seul appel. `includeMonthlyTrends: false` si la tendance ne sert pas |
| `research_keywords` | Idées de requêtes autour de 1 à 5 graines | ~54 crédits par graine (limite 150), ~110 à 500, +40 si la graine est obscure | 5 graines par appel. Ne pas monter `resultLimit`. **Jamais `includeClickstreamData`** : il double le coût |
| `get_serp_results` | Les résultats Google réels pour 1 à 10 requêtes | ~5 crédits par requête à profondeur 20, +2,5 par tranche de 10 | Grouper par 10. Profondeur 10 ou 20, jamais plus sans raison |
| `get_ranked_keywords` | Les requêtes sur lesquelles un domaine ranke | payant | `limit` 50, `minSearchVolume` 10, `excludeBrandTerms` avec le nom du concurrent |
| `get_domain_keyword_suggestions` | Requêtes d'un concurrent, version large | ~100 à 300 crédits, en cache 12 h | Deux ou trois concurrents maximum, les plus proches |
| `find_serp_competitors` | Qui occupe les résultats sur une liste de requêtes | payant | Un seul appel, 10 à 20 requêtes représentatives |
| `get_domain_overview` | Empreinte globale d'un domaine | payant | Rarement utile ici |
| `run_site_audit` | Crawl complet du site | voir sa description | **Inutile ici** : `audit-technique.sh` fait les vérifications essentielles gratuitement |
| backlinks, local, business profile, rank tracker | | payant | Hors du périmètre de cette skill |

## Coûts observés (test du 23/09/2026)

| Appel | Crédits réels |
|---|---|
| `get_keyword_metrics`, 28 requêtes, sans tendances | 19 |
| `research_keywords`, 1 graine, limite 150 + `get_serp_results`, 5 requêtes, profondeur 10 | 62 |

Une étude complète pour une petite activité tient donc en quelques centaines
de crédits.

## L'ordre le moins cher

1. `whoami` et les outils gratuits (projet, Search Console).
2. Les requêtes déjà connues (Search Console, termes de la personne, requêtes
   des concurrents devinées) : **un seul** `get_keyword_metrics`.
3. `research_keywords` sur 3 à 5 graines bien choisies, en un appel.
4. `get_ranked_keywords` sur 2 ou 3 concurrents.
5. Rechiffrer d'un coup les nouvelles requêtes retenues : un `get_keyword_metrics`.
6. `get_serp_results` sur les 10 à 20 finalistes, pour lire qui tient la place.

Annonce le budget de chaque étape en crédits **avant** de la lancer. Au-delà de
1 000 crédits pour une étape, attends un accord explicite.
