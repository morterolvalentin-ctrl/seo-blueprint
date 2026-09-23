#!/usr/bin/env bash
# SEO Blueprint · audit technique d'un site, sans crédit ni compte.
# Usage : audit-technique.sh https://exemple.fr [nb_pages_max]
# Variable optionnelle : PSI_API_KEY (clé gratuite PageSpeed Insights).
# Sortie : un rapport texte brut, ligne par ligne, que la skill interprète.
# Rien n'est modifié sur le site : uniquement des requêtes GET et HEAD.

set -uo pipefail

URL="${1:-}"
MAX_PAGES="${2:-15}"
[ -z "${URL}" ] && { echo "Usage : $0 https://exemple.fr [nb_pages_max]"; exit 1; }
case "${URL}" in http*) ;; *) URL="https://${URL}" ;; esac
URL="${URL%/}"
HOST="$(echo "${URL}" | sed -E 's#https?://##; s#/.*##')"
ROOT="https://${HOST}"
UA="Mozilla/5.0 (compatible; SEO-Blueprint-Audit/1.0)"
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

say()  { printf '%s\n' "$*"; }
sect() { printf '\n## %s\n' "$*"; }
get()  { curl -sL -A "${UA}" --max-time 20 "$@"; }
code() { curl -s -o /dev/null -A "${UA}" --max-time 20 -w '%{http_code}' "$@"; }

# Extrait le contenu d'une balise meta name=... (ordre des attributs quelconque)
meta() {
  META_NAME="$2" perl -0777 -ne 'my $n=quotemeta($ENV{META_NAME}); for my $t (/<meta\b[^>]*>/gis) { if ($t =~ /(?:name|property)\s*=\s*["\x27]$n["\x27]/i) { if ($t =~ /content\s*=\s*"([^"]*)"/is || $t =~ /content\s*=\s*\x27([^\x27]*)\x27/is) { (my $c=$1) =~ s/\s+/ /g; print $c; last } } }' < "$1"
}
title() { tr '\n' ' ' < "$1" | grep -oiE '<title[^>]*>[^<]*</title>' | head -1 | sed -E 's/<[^>]+>//g; s/^ +| +$//g'; }
visible_words() {
  tr '\n' ' ' < "$1" \
    | sed -E 's#<script[^>]*>[^<]*(<[^/][^<]*)*</script>##Ig; s#<style[^>]*>[^<]*</style>##Ig; s#<[^>]+># #g' \
    | wc -w | tr -d ' '
}

say "# Audit technique : ${ROOT}"
say "date: $(date '+%Y-%m-%d %H:%M')"

sect "Accès et redirections"
say "https_racine: $(code "${ROOT}/")"
say "http_vers_https: $(curl -s -o /dev/null -A "${UA}" --max-time 20 -w '%{http_code} -> %{redirect_url}' "http://${HOST}/")"
case "${HOST}" in
  www.*) ALT="${HOST#www.}" ;;
  *)     ALT="www.${HOST}" ;;
esac
say "variante_${ALT}: $(curl -s -o /dev/null -A "${UA}" --max-time 20 -w '%{http_code} -> %{redirect_url}' "https://${ALT}/")"
say "variante_${ALT}_canonical: $(get "https://${ALT}/" | tr '\n' ' ' | grep -oiE '<link[^>]+rel=["'"'"']canonical["'"'"'][^>]*>' | head -1 | sed -E 's/.*href=["'"'"']([^"'"'"']+)["'"'"'].*/\1/')"

get -D "${TMP}/h" -o "${TMP}/home.html" "${URL}/" >/dev/null
say "x_robots_tag_accueil: $(grep -i '^x-robots-tag' "${TMP}/h" | tail -1 | cut -d: -f2- | tr -d '\r' | sed 's/^ //')"
say "meta_robots_accueil: $(meta "${TMP}/home.html" robots)"

sect "robots.txt"
RC="$(code "${ROOT}/robots.txt")"
say "robots_txt_statut: ${RC}"
if [ "${RC}" = "200" ]; then
  get "${ROOT}/robots.txt" > "${TMP}/robots.txt"
  say "robots_bloque_tout: $(awk 'BEGIN{IGNORECASE=1} /^user-agent: *\*/{a=1;next} /^user-agent:/{a=0} a && /^disallow: *\/ *$/{print "OUI"; exit}' "${TMP}/robots.txt")"
  say "robots_sitemaps_declares: $(grep -i '^sitemap:' "${TMP}/robots.txt" | cut -d: -f2- | tr -d '\r' | tr '\n' ' ')"
  say "robots_bots_ia_bloques: $(grep -iE -A2 'user-agent: *(GPTBot|ClaudeBot|anthropic-ai|PerplexityBot|Google-Extended|CCBot)' "${TMP}/robots.txt" | grep -iE 'disallow: */ *$' -B2 | grep -ioE 'GPTBot|ClaudeBot|anthropic-ai|PerplexityBot|Google-Extended|CCBot' | sort -u | tr '\n' ' ')"
fi

sect "Sitemap"
SM=""
for c in $(grep -i '^sitemap:' "${TMP}/robots.txt" 2>/dev/null | cut -d: -f2- | tr -d '\r ') \
         "${ROOT}/sitemap.xml" "${ROOT}/sitemap-index.xml" "${ROOT}/sitemap_index.xml" "${ROOT}/wp-sitemap.xml"; do
  [ "$(code "${c}")" = "200" ] && { SM="${c}"; break; }
done
say "sitemap_trouve: ${SM:-AUCUN}"
: > "${TMP}/urls"
if [ -n "${SM}" ]; then
  get "${SM}" > "${TMP}/sm.xml"
  if grep -qi '<sitemapindex' "${TMP}/sm.xml"; then
    for sub in $(grep -oE '<loc>[^<]+</loc>' "${TMP}/sm.xml" | sed -E 's#</?loc>##g' | head -5); do
      get "${sub}" | grep -oE '<loc>[^<]+</loc>' | sed -E 's#</?loc>##g' >> "${TMP}/urls"
    done
  else
    grep -oE '<loc>[^<]+</loc>' "${TMP}/sm.xml" | sed -E 's#</?loc>##g' >> "${TMP}/urls"
  fi
  say "sitemap_nb_urls: $(wc -l < "${TMP}/urls" | tr -d ' ')"
  [ "$(code "${ROOT}/sitemap.xml")" != "200" ] && say "sitemap_xml_standard: absent (${ROOT}/sitemap.xml ne répond pas 200)"
fi

sect "Fichiers pour les IA"
say "llms_txt: $(code "${ROOT}/llms.txt")"
MD="$(tr '\n' ' ' < "${TMP}/home.html" | grep -oiE '<link[^>]+type=["'\'']text/markdown["'\''][^>]*>' | head -1 | sed -E 's/.*href=["'\'']([^"'\'']+)["'\''].*/\1/')"
say "alternate_markdown_accueil: ${MD:-absent}"
if [ -n "${MD}" ]; then
  case "${MD}" in http*) ;; *) MD="${ROOT}/${MD#/}" ;; esac
  say "alternate_markdown_statut: $(code "${MD}") $(curl -sI -A "${UA}" --max-time 20 "${MD}" | grep -i '^x-robots-tag' | tr -d '\r')"
fi

sect "Accueil"
say "title: $(title "${TMP}/home.html")"
say "title_longueur: $(title "${TMP}/home.html" | wc -m | tr -d ' ')"
say "description: $(meta "${TMP}/home.html" description)"
say "description_longueur: $(meta "${TMP}/home.html" description | wc -m | tr -d ' ')"
say "h1_nombre: $(grep -oiE '<h1[ >]' "${TMP}/home.html" | wc -l | tr -d ' ')"
say "lang: $(grep -oiE '<html[^>]*lang=["'\''][^"'\'']+' "${TMP}/home.html" | head -1 | sed -E 's/.*lang=["'\'']//')"
say "canonical: $(tr '\n' ' ' < "${TMP}/home.html" | grep -oiE '<link[^>]+rel=["'\'']canonical["'\''][^>]*>' | head -1 | sed -E 's/.*href=["'\'']([^"'\'']+)["'\''].*/\1/')"
say "og_title: $(meta "${TMP}/home.html" og:title)"
say "og_image: $(meta "${TMP}/home.html" og:image)"
say "jsonld_types: $(tr '\n' ' ' < "${TMP}/home.html" | grep -oE '"@type" *: *"[A-Za-z]+"' | sed -E 's/.*"([A-Za-z]+)"$/\1/' | sort -u | tr '\n' ' ')"
say "mots_visibles_html_brut: $(visible_words "${TMP}/home.html")"
say "scripts_nombre: $(grep -oiE '<script' "${TMP}/home.html" | wc -l | tr -d ' ')"
say "generateur: $(meta "${TMP}/home.html" generator)"
say "poids_html_octets: $(wc -c < "${TMP}/home.html" | tr -d ' ')"

sect "Doublons d'adresse"
P="$(grep -vE "^${ROOT}/?$" "${TMP}/urls" | head -1)"
if [ -n "${P}" ]; then
  P="${P%/}"
  say "page_test: ${P}"
  say "sans_slash: $(curl -s -o /dev/null -A "${UA}" --max-time 20 -w '%{http_code} -> %{redirect_url}' "${P}")"
  say "avec_slash: $(curl -s -o /dev/null -A "${UA}" --max-time 20 -w '%{http_code} -> %{redirect_url}' "${P}/")"
  say "avec_html: $(curl -s -o /dev/null -A "${UA}" --max-time 20 -w '%{http_code} -> %{redirect_url}' "${P}.html")"
else
  say "page_test: aucune page trouvée hors accueil"
fi
say "page_inexistante_statut: $(code "${ROOT}/cette-page-nexiste-pas-$(date +%s)")"

sect "Pages du sitemap (échantillon de ${MAX_PAGES})"
: > "${TMP}/pages.tsv"
head -n "${MAX_PAGES}" "${TMP}/urls" | while read -r u; do
  f="${TMP}/p.html"
  s="$(curl -sL -A "${UA}" --max-time 20 -o "${f}" -w '%{http_code}' "${u}")"
  t="$(title "${f}")"; d="$(meta "${f}" description)"
  h1="$(grep -oiE '<h1[ >]' "${f}" | wc -l | tr -d ' ')"
  bc="$(grep -c 'BreadcrumbList' "${f}")"
  w="$(visible_words "${f}")"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "${s}" "${h1}" "${bc}" "${w}" "${t}" "${d}" "${u}" >> "${TMP}/pages.tsv"
done
say "colonnes: statut | nb_h1 | breadcrumb_jsonld | mots | title | description | url"
cat "${TMP}/pages.tsv"
say "titles_en_double: $(cut -f5 "${TMP}/pages.tsv" | sort | uniq -d | wc -l | tr -d ' ')"
say "descriptions_en_double: $(cut -f6 "${TMP}/pages.tsv" | grep -v '^$' | sort | uniq -d | wc -l | tr -d ' ')"
say "descriptions_vides: $(cut -f6 "${TMP}/pages.tsv" | grep -c '^$')"
say "pages_sans_breadcrumb: $(awk -F'\t' '$3==0' "${TMP}/pages.tsv" | wc -l | tr -d ' ')"
say "pages_title_egal_description: $(awk -F'\t' '$5!="" && $5==$6' "${TMP}/pages.tsv" | wc -l | tr -d ' ')"

sect "PageSpeed Insights"
for strat in mobile desktop; do
  q="url=${URL}/&strategy=${strat}&category=performance&category=accessibility&category=best-practices&category=seo"
  [ -n "${PSI_API_KEY:-}" ] && q="${q}&key=${PSI_API_KEY}"
  curl -s --max-time 120 "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?${q}" > "${TMP}/psi.json"
  if grep -q '"lighthouseResult"' "${TMP}/psi.json"; then
    scores="$(grep -oE '"(performance|accessibility|best-practices|seo)": *\{[^{}]*"score": *[0-9.]+' "${TMP}/psi.json" \
      | sed -E 's/"([a-z-]+)".*"score": *([0-9.]+)/\1=\2/' | awk -F= '{printf "%s=%d ", $1, $2*100+0.5}')"
    say "psi_${strat}: ${scores}"
    for m in largest-contentful-paint cumulative-layout-shift total-blocking-time first-contentful-paint; do
      v="$(tr '\n' ' ' < "${TMP}/psi.json" | grep -oE "\"${m}\": *\{[^}]*\"displayValue\": *\"[^\"]*\"" | head -1 | sed -E 's/.*"displayValue": *"([^"]*)".*/\1/')"
      say "psi_${strat}_${m}: ${v}"
    done
    say "psi_${strat}_a_corriger: $(tr '\n' ' ' < "${TMP}/psi.json" | grep -oE '"id": *"[a-z0-9-]+", *"title": *"[^"]*", *"description": *"[^"]*", *"score": *0(\.[0-4][0-9]*)?[,}]' | sed -E 's/"id": *"([a-z0-9-]+)".*/\1/' | head -12 | tr '\n' ' ')"
  else
    say "psi_${strat}: ECHEC $(grep -oE '"message": *"[^"]*"' "${TMP}/psi.json" | head -1)"
  fi
done

say ""
say "fin_audit"
