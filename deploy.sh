#!/usr/bin/env bash
#
# Auslieferung der Projektseite auf dem Server.
#
#   ssh forge
#   /opt/ref4ep-webseite/deploy.sh
#
# Holt den aktuellen Stand aus dem Repo und gleicht ihn mit dem
# Web-Root ab. Der nginx-Konfiguration wird dabei nicht angefasst und
# das .git-Verzeichnis landet nie im Web-Root — es waere sonst ueber
# https://www.ref4ep.de/.git/config oeffentlich lesbar.
#
# Laeuft ohne sudo, sofern die einmalige Einrichtung erfolgt ist
# (siehe README, Abschnitt "Ausliefern").

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZIEL="/var/www/ref4ep"

if [ ! -d "$ZIEL" ]; then
    echo "Web-Root $ZIEL existiert nicht." >&2
    exit 1
fi
if [ ! -w "$ZIEL" ]; then
    echo "Keine Schreibrechte auf $ZIEL — einmalige Einrichtung fehlt (README)." >&2
    exit 1
fi

echo "==> Stand aus dem Repo holen"
git -C "$REPO" pull --ff-only

echo "==> Abgleich nach $ZIEL"
# --delete raeumt entfernte Dateien auf. Ausgenommen bleiben:
#   .git und Repo-Beiwerk        gehoeren nicht ins Web-Root
#   software/*/download/         Installationsdateien liegen nur hier
#   *.bak-*                      aeltere Sicherungen von Hand
rsync -a --delete \
    --exclude '.git/' \
    --exclude '.gitignore' \
    --exclude 'README.md' \
    --exclude 'deploy.sh' \
    --exclude '_vorschau-screenshots/' \
    --exclude 'software/*/download/' \
    --exclude '*.bak-*' \
    "$REPO"/ "$ZIEL"/

echo "==> Fertig. Kurztest:"
for pfad in / /software/ /software/iontrace/ /assets/style.css; do
    code=$(curl -s -o /dev/null -w '%{http_code}' "https://www.ref4ep.de${pfad}")
    printf '    %-28s %s\n' "$pfad" "$code"
done
