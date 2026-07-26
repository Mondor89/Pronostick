# Pronostick.Code — Laboratorio locale

Cartella per generare e affinare pronostici sportivi usando Claude Code (WebSearch nativo +
ragionamento), senza consumare l'API a pagamento del Pronostick reale. Nasce per allenare il
ragionamento di analisi a costo zero (piano Pro di Fabio), prima di eventualmente portare un
miglioramento nel Pronostick reale — sempre a mano, mai in automatico.

## Struttura

- `pronostici/` — un file JSON per partita analizzata, con l'eventuale verifica una volta giocata.
  Dati generati da Claude Code tramite ricerche AI, **gitignored** — mai committati (non sono dati
  definitivi, sono pronostici/giudizi generati, stesso principio delle foto/dati di vendita di
  Bracco).
- `_inbox/` — riservata alle richieste che una futura dashboard (Sessione 2, non ancora costruita)
  scriverà qui. Al momento **non è necessaria**: basta chiedere direttamente a Claude Code di
  analizzare una partita in una sessione con la skill `analizza-locale` attiva.

## Cosa governa questa cartella

`.claude/skills/analizza-locale/SKILL.md` — schema dati, procedura di analisi/verifica, logica
delle lezioni apprese. Se qualcosa nel processo non funziona, si corregge lì con `!patch` (vedi
il file).

⚠️ **Nessun collegamento al Pronostick reale.** Dati, memoria/lezioni, tutto vive solo qui —
niente localStorage, niente Firestore, niente API key. Un eventuale miglioramento di ragionamento
scoperto qui va portato nel Pronostick reale (`buildPrompt()` in `index.html`) sempre a mano.

## Roadmap

- [x] Sessione 1 — fondamenta (questa cartella + skill `analizza-locale`)
- [ ] Sessione 2 — dashboard (`dashboard.html`, File System Access API, stesso stile dell'app originale)
- [ ] Sessione 3 — Guida/FAQ dedicata al processo Claude Code
