# Checklist technique

La grille que la skill applique au résultat de `audit-technique.sh`. Chaque
point dit **quoi regarder**, **à quoi ressemble le bon état**, et **pourquoi**.
Un site neuf n'a ni historique, ni lien, ni notoriété : la seule chose qu'il
peut offrir à Google au départ, c'est un site propre.

Priorités :
- **P0 bloquant** : tant que ce n'est pas corrigé, rien d'autre ne sert.
- **P1 important** : coûte des positions ou des citations par l'IA.
- **P2 confort** : à faire quand le reste est propre.

---

## 1. Les verrous d'indexation (P0)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| robots.txt n'interdit pas tout | `robots_bloque_tout` | vide | `Disallow: /` sous `User-agent: *` empêche Google de lire le site |
| Pas de noindex global | `x_robots_tag_accueil`, `meta_robots_accueil` | ni `noindex` ni `none` | Un site en construction garde souvent un en-tête noindex. Si robots.txt bloque aussi, Google ne voit même pas le noindex |
| Les robots d'IA ne sont pas bloqués | `robots_bots_ia_bloques` | vide, sauf choix assumé | Bloquer GPTBot, ClaudeBot ou PerplexityBot, c'est renoncer à être cité par ces IA |
| La page d'accueil répond 200 | `https_racine` | 200 | |

## 2. Une page, une adresse (P1)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| http redirige vers https | `http_vers_https` | 301 ou 308 vers https | Deux versions du site = deux sites pour Google |
| www et sans www : une seule version | `variante_*` | 301/308 vers la version principale. À défaut, un canonical qui pointe vers la version principale | Sans redirection, le site existe en double. Le canonical limite les dégâts mais la redirection est la vraie correction |
| /page, /page/ et /page.html ne sont pas trois pages | `sans_slash`, `avec_slash`, `avec_html` | une seule répond 200, les autres redirigent en 301/308, ou répondent 404 | Trois adresses pour un contenu divisent les signaux |
| Chaque page déclare son canonical | `canonical` | l'URL propre de la page | |
| Les URL qui changent sont redirigées en 301 | à vérifier à la main | jamais de 302 pour un déplacement définitif | Une 302 dit à Google que l'ancienne adresse va revenir |
| Vérifier l'adresse technique de l'hébergeur | à vérifier à la main | ex. `monsite.vercel.app`, `monsite.netlify.app` redirigée ou en noindex | Sinon le site entier existe en double sur une autre adresse |

## 3. Aucune impasse (P1)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| Une page inexistante répond 404 | `page_inexistante_statut` | 404, pas 200 | Une « soft 404 » (200 sur une page vide) pollue l'index |
| La page 404 a une navigation et du noindex | à vérifier à la main | liens vers l'accueil et les pages principales | Le robot et le visiteur repartent au lieu de sortir |
| Chaque page est liée depuis au moins une autre | à vérifier à la main | aucune page orpheline | Une page que rien ne lie est découverte tard, ou jamais |
| Un fil d'Ariane sur chaque page, balisé en BreadcrumbList | `breadcrumb_jsonld`, `pages_sans_breadcrumb` | 1 sur toutes les pages sauf l'accueil | Le robot comprend la hiérarchie et passe d'une page à l'autre sans se perdre. Google l'affiche aussi dans le résultat |

## 4. Un sitemap déclaré (P1)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| Un sitemap existe | `sitemap_trouve` | une URL | |
| Il est déclaré dans robots.txt | `robots_sitemaps_declares` | l'URL du sitemap | |
| `/sitemap.xml` répond | `sitemap_xml_standard` | pas de ligne « absent » | Beaucoup d'outils cherchent `/sitemap.xml` d'office. Une redirection vers le vrai fichier suffit |
| Il contient toutes les pages utiles | `sitemap_nb_urls` | à comparer au nombre de pages réel | |
| Déclaré dans la Search Console et dans Bing Webmaster Tools | à vérifier à la main | les deux | Bing alimente aussi la recherche de ChatGPT |

## 5. Chaque page dit ce qu'elle est (P1)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| Un title par page, différent des autres | `titles_en_double` | 0 | |
| Title de 30 à 60 caractères | `title_longueur` | entre 30 et 60 | Au-delà, Google coupe |
| Une description par page, différente des autres | `descriptions_en_double`, `descriptions_vides` | 0 et 0 | |
| Description de 120 à 160 caractères | `description_longueur` | entre 120 et 160 | |
| Title et description ne répètent pas la même phrase | `pages_title_egal_description` | 0 | Deux champs, deux rôles : le title nomme, la description donne envie de cliquer |
| Un seul H1 par page | `nb_h1`, `h1_nombre` | 1 | |
| La langue est déclarée | `lang` | `fr`, `en`… | |
| Balises Open Graph | `og_title`, `og_image` | remplies | L'aperçu quand le lien est partagé sur LinkedIn, Slack, WhatsApp |

## 6. Le texte est lisible sans JavaScript (P0 pour l'IA, P1 pour Google)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| Le texte est dans le HTML servi | `mots_visibles_html_brut`, colonne `mots` | plusieurs centaines de mots sur une page de contenu. Moins de 50 = le texte est probablement construit en JavaScript | Google exécute le JavaScript, en différé. La plupart des robots d'IA ne l'exécutent pas du tout : ils voient une page vide |
| Nombre de scripts raisonnable | `scripts_nombre` | pas de seuil strict, à croiser avec la performance | |

## 7. Les fichiers pour les IA (P1)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| Un `llms.txt` à la racine | `llms_txt` | 200 | Un résumé de la boîte et la liste des pages importantes, écrit pour les modèles de langage. Ce qu'ils lisent en premier quand ils arrivent sur le site |
| Une copie markdown de chaque page | `alternate_markdown_accueil` | une URL `.md` | Le HTML sert Google et les visiteurs, la version markdown sert les LLM, qui la lisent plus facilement et la citent mieux |
| Cette copie est en noindex | `alternate_markdown_statut` | `x-robots-tag: noindex` | Sinon Google voit un doublon de chaque page |
| Elle est signalée dans la page | `alternate_markdown_accueil` | `<link rel="alternate" type="text/markdown" href="...">` | Sans ce lien, les robots ne la trouvent pas |
| Données structurées | `jsonld_types` | au minimum `Organization` et `WebSite` sur l'accueil, `BreadcrumbList` partout, `FAQPage` là où il y a une FAQ, `Article` sur les articles | Google et les IA comprennent qui parle et de quoi |

## 8. La vitesse : PageSpeed Insights (P1)

| Point | Champ du script | Bon état | Pourquoi |
|---|---|---|---|
| Performance mobile | `psi_mobile` performance | 90 et plus, viser 100 | Google classe sur la version mobile |
| Performance desktop | `psi_desktop` performance | 90 et plus | |
| SEO, accessibilité, bonnes pratiques | `psi_*` | 90 et plus, viser 100 partout | Chaque point perdu est une liste de corrections précises, gratuites |
| LCP | `psi_mobile_largest-contentful-paint` | moins de 2,5 s | |
| CLS | `psi_mobile_cumulative-layout-shift` | moins de 0,1 | |
| Les audits en échec | `psi_*_a_corriger` | liste vide | Chaque identifiant est un audit Lighthouse : le nommer et dire quoi faire |

Méthode : ne demande pas « optimise mon site ». Donne le rapport, obtiens la
**liste** des corrections, puis corrige une par une et relance.

## 9. Après l'ouverture : les gestes manuels (P1)

Le script ne peut pas les voir. La skill les demande.

- Search Console : propriété créée, sitemap soumis.
- **Demander l'indexation à la main, page par page** (inspection d'URL). Le
  quota tourne autour de 10 à 12 URL par jour : les pages qui comptent d'abord.
  Sans ce geste, comptez de quelques jours à trois semaines.
- Bing Webmaster Tools : site ajouté (import possible depuis la Search Console).
- IndexNow activé : Bing, Yandex et d'autres sont prévenus à chaque publication.
- Test des résultats enrichis de Google sur une page type : le balisage est-il lu ?

## 10. Le contenu (P1, revu en phase de recherche)

Ce n'est pas de la technique, mais c'est ce qui décide du classement. La skill
y revient quand elle propose le plan de pages.

- **Une page répond à une question, mot pour mot.** La requête dans le title et
  le H1, la réponse chiffrée dès la première ligne, sans arrondi, puis une
  section par sous-question.
- **Fraîcheur** : la page est datée, porte l'année dans le title quand c'est
  pertinent, et elle est mise à jour au moins une fois par an.
- **Contenu propriétaire** : une information qui n'existe nulle part ailleurs.
  Les IA citent ce qu'elles trouvent, elles ne peuvent pas citer un chiffre qui
  n'existe pas. C'est le signal le plus sous-estimé.
- **Segmentation** : découper la réponse par sous-catégorie. Chaque segment est
  une requête de plus.
- **Maillage** : chaque page d'une même thématique pointe vers les autres et
  vers la page principale.
- **Pas de production de masse d'un coup** : 10 à 15 pages par thématique,
  reliées entre elles, puis on mesure. Publier 80 pages quasi identiques en
  une fois expose à un classement en contenu de faible qualité.
- **Contenu réservé** : si une partie demande un e-mail, le texte reste présent
  dans le HTML. Google et les IA le lisent.

## 11. La notoriété et les liens (P2 au départ, P1 ensuite)

- **La requête de marque** : faire que des gens intéressés tapent votre nom et
  cliquent sur votre site. Petit geste : le nom de marque dans la signature
  mail, sans lien. Le volume vient de la notoriété : contenu régulier (LinkedIn,
  newsletter), études reprises par la presse de votre secteur.
- **Les backlinks qui comptent** : presse spécialisée (une vraie information à
  publier, une étude en exclusivité se propose), annuaires thématiques et
  répertoires spécialisés de votre secteur, partenaires.
- **Jamais d'achat de liens en masse** avant d'avoir validé une verticale.
