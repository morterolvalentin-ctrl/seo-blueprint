#!/usr/bin/env bash
# SEO Blueprint · installation
# Copie la skill seo-audit dans ~/.claude/skills/ et ses fichiers dans
# ~/.claude/seo-blueprint/. Ne touche à rien d'autre et n'installe aucune clé.

set -euo pipefail

REPO="https://github.com/morterolvalentin-ctrl/seo-blueprint.git"
SKILLS_DIR="${HOME}/.claude/skills"
CONF_DIR="${HOME}/.claude/seo-blueprint"
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

bold() { printf '\033[1m%s\033[0m\n' "$1"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }

bold "SEO Blueprint · installation"
echo

command -v git  >/dev/null || { echo "git est requis.";  exit 1; }
command -v curl >/dev/null || { echo "curl est requis."; exit 1; }
command -v perl >/dev/null || warn "perl absent : l'audit technique lira moins bien les balises meta"

if [ -n "${SEO_BLUEPRINT_SRC:-}" ]; then
  cp -R "${SEO_BLUEPRINT_SRC}" "${TMP}/repo"
else
  git clone --depth 1 -q "${REPO}" "${TMP}/repo"
fi
ok "dépôt récupéré"

mkdir -p "${SKILLS_DIR}" "${CONF_DIR}"

s=seo-audit
if [ -d "${SKILLS_DIR}/${s}" ]; then
  backup="${SKILLS_DIR}/${s}.backup-$(date +%Y%m%d-%H%M%S)"
  mv "${SKILLS_DIR}/${s}" "${backup}"
  warn "${s} existait déjà, sauvegardée dans $(basename "${backup}")"
fi
cp -R "${TMP}/repo/skills/${s}" "${SKILLS_DIR}/${s}"
ok "skill ${s} installée"

cp "${TMP}/repo/scripts/audit-technique.sh" "${CONF_DIR}/audit-technique.sh"
chmod +x "${CONF_DIR}/audit-technique.sh"
for f in checklist-technique.md openseo.md modele-rapport.md; do
  cp "${TMP}/repo/references/${f}" "${CONF_DIR}/${f}"
done
ok "script d'audit et références copiés dans ~/.claude/seo-blueprint/"

echo
bold "C'est installé. Ensuite :"
echo
echo "    claude"
echo "    /seo-audit"
echo
echo "La skill te demande si tu as un site. Avec un site, elle commence par un"
echo "audit technique gratuit. Sans site, elle part de ton activité."
echo "OpenSEO (données de recherche) se branche en cours de route, elle te"
echo "donne la commande au bon moment."
echo
