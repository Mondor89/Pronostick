#!/usr/bin/env bash
# Controllo euristico per i pattern-trappola documentati in CLAUDE.md
# (bug reali trovati nel code review del 14/07/2026). Non sostituisce
# la revisione manuale: segnala righe sospette da controllare a mano.
set -uo pipefail

export LC_ALL=C.UTF-8

FILE="${1:-index.html}"
FOUND=0

if [ ! -f "$FILE" ]; then
  echo "File non trovato: $FILE"
  exit 1
fi

echo "Controllo pattern-trappola in: $FILE"
echo "======================================"

echo ""
echo "--- [1] '+' seguito da '?' senza parentesi (precedenza ternario) ---"
if grep -nP '\+\s*[A-Za-z_][\w.]*\s*\?' "$FILE"; then
  FOUND=1
fi

echo ""
echo "--- [2] '+' seguito da '||' senza parentesi (precedenza OR) ---"
if grep -nP '\+\s*[A-Za-z_][\w.]*\s*\|\|' "$FILE"; then
  FOUND=1
fi

echo ""
echo "--- [3] \${...} dentro apici singoli/doppi invece di backtick (non interpola) ---"
if grep -nP "'[^'\n]*\\\$\{[^'\n]*'" "$FILE"; then
  FOUND=1
fi
if grep -nP "\"[^\"\n]*\\\$\{[^\"\n]*\"" "$FILE"; then
  FOUND=1
fi

echo ""
echo "--- [4] Campi utente (team1/team2/competition/sport/matchDate) in template literal senza escapeHtml() sulla stessa riga ---"
if grep -nP '\$\{(team1|team2|competition|sport|matchDate)[^}]*\}' "$FILE" | grep -vP 'escapeHtml'; then
  echo "^ verificare manualmente che questi campi passino da escapeHtml() prima di finire nel DOM"
  FOUND=1
fi

echo ""
echo "======================================"
if [ "$FOUND" -eq 1 ]; then
  echo "Trovate righe da rivedere manualmente (vedi sopra). Non tutti i match sono bug reali: e' un controllo euristico."
  exit 1
else
  echo "Nessun pattern sospetto trovato."
  exit 0
fi
