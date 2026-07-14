# CLAUDE.md — Pronostick

> Letto automaticamente da Claude Code ad ogni sessione su questo progetto.
> Struttura: app single-file (HTML+CSS+JS inline) + backend serverless minimo (proxy API key).

---

## ⚡ REGOLA DI AVVIO — Prima cosa da fare [UNIVERSALE]

**Claude deve, ogni volta che apre questo file per la prima volta in una sessione:**

1. Leggere questo file dall'inizio alla fine prima di fare qualsiasi altra cosa.
2. Il progetto **non è nuovo** (`pronostick_stato.md` esiste, git ha commit) → comportamento normale: leggi i file `.md`, produci il RIEPILOGO se richiesto, attendi.

---

## Identità del progetto

**Nome:** Pronostick
**Cosa fa:** Genera pronostici sportivi con l'AI (Claude) — analisi live, value bet, storico pronostici e calendario partite
**Target:** Uso personale (+ eventuali altri utenti via login Google/Firebase)
**Stack tecnico:** HTML+CSS+JS single-file (`index.html`, ~4800+ righe)
**Backend/hosting:** Netlify + Netlify Functions (`netlify/functions/proxy.js`)
**API esterne usate:** Anthropic API (pattern BYOK — l'utente inserisce la propria key), Firebase Auth + Firestore (sync cross-device)
**Repository:** https://github.com/Mondor89/Pronostick (main branch, cartella locale collegata via git)
**Deploy:** https://pronostick.netlify.app/ (auto-deploy da GitHub)

---

## Documentazione del progetto

- `pronostick_stato.md` — stato, focus, task aperte/completate, decisioni prese, alternative scartate, bug noti, log sessioni (tutto in un file — aggiornato manualmente da Fabio o via comando REGISTRA)
- `pronostick_sicurezza.md` — invarianti di sicurezza (secret, escaping, isolamento dati utente Firestore)

---

## Come lavoriamo [UNIVERSALE]

- Si lavora **una funzionalità alla volta**: costruisci → testa → valida → avanti
- Il codice non deve essere perfetto, deve funzionare ed essere comprensibile da chi lo mantiene
- Fabio decide sempre la direzione finale
- Risposte **concise e strutturate**, in italiano
- Una domanda aperta di Fabio ("cosa ne pensi?", "che ne dici?", "come lo vedresti?") è una richiesta di discussione, **non un via libera a implementare**. Proporre l'idea/alternativa a parole e attendere conferma esplicita prima di scrivere codice — anche se la proposta sembra ovviamente buona.
- Se un bug è puramente visivo (layout rotto, colori sbagliati, elemento che non appare) e il codice sembra corretto, controllare PRIMA CSS/attributi/ordine di caricamento prima di sospettare la logica JS.

### Comandi speciali

**RIEPILOGO** — Leggi `pronostick_stato.md` e `pronostick_sicurezza.md` e produci un riepilogo in 5-6 righe:
stato attuale, ultima decisione presa, task di questa sessione. Poi attendi.

**REGISTRA** — Leggi tutti i file `.md` e aggiornali con quanto emerso nella sessione.
Indica cosa è cambiato in ogni file. Poi fai `git add . && git commit` (chiedi conferma prima del push, salvo diversa indicazione di Fabio).

**Checklist obbligatoria REGISTRA — rispondere sì/no a ogni voce, aggiornare se sì:**

| File | Domanda trigger |
|------|----------------|
| `pronostick_stato.md` | Ci sono task completati, aperti o spostati, decisioni prese, alternative scartate questa sessione? |
| `pronostick_sicurezza.md` | Sono cambiate invarianti di sicurezza, o è emersa una nuova funzionalità che tocca secret/dati utente? |
| `CLAUDE.md` | Ci sono nuove regole, principi prodotto confermati, task aggiornati o idee scartate? |

> ⚠️ Eseguire REGISTRA leggendo la checklist NON basta — ogni file va APERTO e confrontato con quanto emerso nella sessione.

**REVISIONA [nome funzionalità]** — Analizza la funzionalità indicata contro tutti i Principi Prodotto.
Rispondi con: ✅ compatibile / ⚠ conflitto potenziale / ❌ violazione diretta — per ciascun principio.
Poi attendi conferma prima di procedere con il codice.

**VERIFICA-SICUREZZA [nome funzionalità]** — Analizza la funzionalità contro `pronostick_sicurezza.md`.
Rispondi con: ✅ OK / ⚠ Attenzione / ❌ Violazione per ogni invariante rilevante.
Poi attendi conferma prima di procedere con il codice.

> **Soglia di attivazione:**
> ✅ USARE per: nuova funzionalità, nuovo punto di input utente, nuova integrazione con API esterna, nuovo dato persistito
> ⏭ SALTARE per: bugfix UI puro, refactor senza impatto su dati/secret, tweak di stile

---

## Ruolo di Claude come guardiano del prodotto [UNIVERSALE]

**Ad ogni sessione e ad ogni nuova funzionalità**, Claude deve:

1. **Verificare** coerenza con Principi Prodotto (REVISIONA) **e** invarianti di sicurezza (VERIFICA-SICUREZZA)
2. **Avvisare proattivamente** se rileva:
   - Un secret/API key che finirebbe nel codice frontend committato
   - Un nuovo punto di input utente che finisce nel DOM senza sanificazione
   - Debito tecnico difficile da ripagare dopo
   - Una funzionalità nuova non coperta da nessun principio (gap)
3. **Non procedere silenziosamente** quando c'è un conflitto — segnalarlo prima di scrivere codice

---

## Gestione finestra di contesto [UNIVERSALE — SEMPRE ATTIVA]

**Livello 1 — ~60–70% consumato:** ⚠️ Consiglio di eseguire `/compact` ora.
**Livello 2 — ~85% consumato:** 🔴 Contesto quasi esaurito. Eseguire `/compact` prima di continuare.
**Dopo `/compact`:** Rilancia RIEPILOGO automaticamente prima di riprendere. Non aspettare che Fabio lo chieda.

---

## Gestione modello — quando suggerire un cambio [UNIVERSALE — SEMPRE ATTIVA]

> Claude non può cambiare modello da solo nella conversazione principale (`/model` lo esegue solo Fabio). Esiste anche lo slider **"Impegno"** (6 livelli), indipendente dal modello.

**Quando proporre il modello intermedio:** bug tecnico dopo 2 tentativi falliti sullo stesso sintomo senza progressi; nuova funzionalità che tocca 3+ punti del codice.

**Quando proporre il modello più potente:** revisione completa del codice, decisione architetturale difficile da disfare (es. cambio provider auth/storage), audit di sicurezza esplicito richiesto da Fabio.

**Quando restare sul modello base:** fix singolo e localizzato, test + correzioni, tweak UI/testo, refactor piccolo.

**Come proporlo:** motivazione con (1) perché serve più potenza, (2) quale livello e perché, (3) rischio restando sul base. Poi `/model` manuale. Non bloccare il lavoro in attesa — proporre e continuare, salvo blocco reale.

**Autocalibrazione:** se Fabio segnala una proposta eccessiva o mancata, salvare la correzione in memoria (tipo `feedback`).

---

## Meta-regole [UNIVERSALE]

- Ogni regola ha il "perché", non solo il "cosa"
- **[PERMANENTE]** vale per tutta la vita del progetto — **[PROTOTIPO]** va rivalutata prima di un uso più ampio/pubblico
- Cambiare una regola richiede: decisione esplicita di Fabio con motivazione → aggiornamento di CLAUDE.md → nota sul perché

**Gerarchia in caso di conflitto:**
1. Sicurezza dei dati (mai un secret esposto, mai un dato utente accessibile ad altri)
2. Funziona per lo scopo reale (pronostici utili, senza friction inutile)
3. Semplicità di manutenzione (Fabio non è uno sviluppatore senior)
4. Pulizia tecnica (ma non a scapito dei punti sopra)

---

## Principi di debug e architettura [UNIVERSALE]

- **Prima di scrivere codice nuovo, verificare cosa il sistema esistente già permette.** Una richiesta "vorrei che X potesse fare anche Y" spesso non richiede una feature nuova.
- **Un fallback silenzioso che crea dati "vuoti" è più pericoloso di un errore esplicito.** Meglio fallire in modo visibile che generare un placeholder che sembra valido ma non lo è.
- **Un bug che sembra "strano" o "impossibile" nasce spesso da precedenza degli operatori, non da logica sbagliata.** Vedi "Regole JavaScript/Web" più sotto — Pronostick aveva 4 bug reali di questo tipo (corretti il 14/07/2026).

---

## Limite di complessità per sessione [UNIVERSALE]

**Una sessione risolve UNA cosa sola:** una funzionalità completa, oppure una serie di bug correlati allo stesso punto del codice, oppure una sessione di code/security review senza nuove funzionalità.
Se emerge un bug altrove, annotarlo in "Bug Noti" di `pronostick_stato.md` e tornarci dopo.

---

## Fase attuale

**Funzionante** — l'app è deployata e usata regolarmente, gestione errori di base presente. Non ancora "Rifinito": resta aperta la verifica delle regole di sicurezza Firestore (vedi `pronostick_sicurezza.md`) prima di poterla considerare verificata lato sicurezza.

---

## Principi Prodotto

### 1. Nessun secret nel frontend [PERMANENTE]
**Perché:** il codice client è sempre leggibile da chiunque apra gli strumenti sviluppatore.
**Cosa:** l'API key Anthropic non è mai hardcoded — pattern BYOK, l'utente inserisce la propria key salvata in `localStorage`, inoltrata dal proxy Netlify che non la logga né la salva.

### 2. Semplicità di manutenzione [PERMANENTE]
**Perché:** Fabio non è uno sviluppatore senior — un'architettura complessa diventa impossibile da mantenere da solo.
**Cosa:** niente build step/framework pesanti, single-file HTML, ogni scelta tecnica non ovvia va spiegata in chiaro.

### 3. Costo API sotto controllo [PERMANENTE]
**Perché:** un uso non monitorato dell'API Anthropic (a consumo) può generare costi imprevisti sull'account dell'utente.
**Cosa:** il pannello costi (Token AI, Web Search, Cerca Quote) resta sempre visibile e aggiornato prima di operazioni che consumano token.

### 4. Gioco responsabile sempre visibile [PERMANENTE]
**Perché:** l'app tratta scommesse sportive — un pronostico AI non è mai una garanzia di vincita.
**Cosa:** il disclaimer "Gioco Responsabile" nel risultato dell'analisi non va mai rimosso, nascosto o reso meno visibile.

---

## Idee in pausa

| Idea | Perché in pausa | Fase giusta |
|------|----------------|-------------|
| Sistema Tag Pattern per AI Memory | Serve prima raccogliere 30+ pronostici verificati | Dopo accumulo dati storico |

## Idee scartate

| Idea | Perché scartata |
|------|----------------|
| Backend custom | Troppo complesso senza esperienza di programmazione |
| Sonnet come modello su Tier 1 Anthropic | Rate limit più basso di Haiku, passare solo da Tier 2 (≥$40 spesi) |
| Service Worker con blob URL | Crash Android confermato |

---

## Struttura file progetto

```
Pronostick/
├── CLAUDE.md                     ← questo file
├── index.html                    ← app single-file (HTML+CSS+JS inline, ~4800+ righe)
├── pronostick_stato.md            ← stato, task, decisioni, alternative, bug noti, log
├── pronostick_sicurezza.md        ← invarianti di sicurezza
├── netlify.toml                   ← config deploy Netlify
└── netlify/functions/proxy.js     ← proxy serverless verso Anthropic API (BYOK)
```

Se `index.html` dovesse superare le ~6000 righe o servissero più pagine distinte, valutare lo split in una struttura multi-file (vedi `CLAUDE_APP_TEMPLATE.md`).

---

## Definizione di "funzionalità completata" [UNIVERSALE]

- [ ] REVISIONA eseguito se la funzionalità è significativa
- [ ] VERIFICA-SICUREZZA eseguito se tocca dati/secret/input esterni
- [ ] Fabio ha approvato prima dell'implementazione
- [ ] Testato manualmente end-to-end (flusso reale)
- [ ] Casi edge testati (input vuoto, errore rete/API, dato malformato)
- [ ] Nessun `console.log`/debug rimasto
- [ ] `pronostick_stato.md` aggiornato

---

## Checklist pre-commit [UNIVERSALE]

- [ ] Nessun errore in console del browser
- [ ] Testato manualmente il flusso principale
- [ ] Nessun `console.log`/debug dimenticato
- [ ] Nessun secret/API key hardcoded nel codice committato
- [ ] `pronostick_stato.md` aggiornato
- [ ] `pronostick_sicurezza.md` aggiornato se emerse nuove invarianti
- [ ] `CLAUDE.md` aggiornato se struttura o principi cambiati

Messaggio commit: `Sessione N — [funzionalità] / [cosa fatto] / [cosa resta]`

---

## Regole JavaScript / Web — pattern-trappola [PERMANENTE]

> Bug reali trovati in questo progetto il 14/07/2026 — vedi `pronostick_stato.md` per i dettagli.

### Precedenza operatori — `+` batte `? :` e `||` [PERMANENTE]
- `'a' + b ? x : y` NON è `'a' + (b ? x : y)` — è `('a' + b) ? x : y`, e la condizione è quasi sempre truthy, quindi `y` non si usa mai.
- `'a' + b || c` NON è `'a' + (b || c)` — è `('a' + b) || c`, quasi sempre truthy, quindi `c` non si usa mai.
- **Regola pratica:** parentesizzare sempre esplicitamente quando `+` si mescola con `? :` o `||`.

### Interpolazione stringhe — backtick, non apici [PERMANENTE]
- `${variabile}` funziona SOLO dentro backtick. Dentro apici singoli/doppi è testo letterale, non viene mai sostituito.

### Escaping HTML — mai fidarsi dell'input, nemmeno il proprio [PERMANENTE]
- Qualsiasi valore da un campo utente che finisce in `innerHTML` va passato da `escapeHtml()` — applicato in modo coerente in TUTTI i punti dove quel dato viene renderizzato (in `index.html`: `renderResult()`, `buildFullDetailHTML()`, `buildCompactCardDOM()`).

### localStorage — chiave stabile [PERMANENTE]
- `pronostick_apikey`, `pronostick_v3_history`, `pronostick_model` sono le chiavi correnti — non cambiarle senza gestire esplicitamente la migrazione dei dati esistenti (vedi `loadHistory()` per il pattern di migrazione già usato).

---

## Note permanenti

- Fabio non è uno sviluppatore senior — spiegare le scelte architetturali non ovvie
- Preferenza per stack semplice: niente build step/framework pesante
- L'app usa l'API Anthropic a consumo (BYOK) — monitorare che il pannello costi resti accurato quando si aggiungono chiamate
- Firebase è usato per Auth + Firestore, non per hosting (quello è su Netlify)
