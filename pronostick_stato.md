# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 14/07/2026 |
| **Ultima sessione** | Code review completa (Sonnet 5, impegno alto) — 18 problemi trovati, 10 corretti e verificati (A1-A5, B1-B5) |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata. Eseguita code review completa (codice + UI) il 14/07/2026 con Sonnet 5 impegno alto: emersi 18 problemi, annotati in Bug Noti per priorità. Chiusi in questa sessione tutti i 10 bug funzionali/di sicurezza trovati (A1-A5, B1-B5) — restano aperti solo i 7 minori/incoerenze (C1, C3-C7) e i 6 di UI/UX (D1-D6), nessuno bloccante, da programmare quando serve. Prossimo passo: sistema Tag Pattern per AI Memory.

---

## Navigazione UI — 6 Tab
1. ⚡ Analizza — genera pronostici AI
2. 🎯 Giocata — trova giocata ottimale automaticamente
3. 📅 Calendario — cerca e salva partite della settimana
4. 📚 Storico — storico pronostici + Statistiche + Combinata
5. ❓ Guida — guida completa
6. ⚙️ Menu — API key, modello AI, account Google, backup

---

## Task Aperte

### Priorità Alta
- [ ] Sistema Tag Pattern per AI Memory (con 30+ pronostici verificati)
- [ ] Upgrade modello a Sonnet quando Tier 2 (≥$40 spesi)

### Priorità Bassa
- [ ] Da definire nelle prossime sessioni

---

## Task Completate
> Le voci più vecchie/dettagliate sono compresse in Archivio Log.
- [x] App web single-page completa con 6 tab (Analizza, Giocata, Calendario, Storico, Guida, Menu)
- [x] Integrazione Anthropic API via proxy Netlify, Firebase Firestore (sync) + Google Auth
- [x] Dropdown 16 sport + mercati dinamici + pannello costi + Cerca Quote + AI Memory
- [x] Cartella locale collegata al repo GitHub — Claude Code committa/pusha direttamente; Python+Node installati in locale per anteprima prima del push (`.claude/launch.json`, `localhost:8080`)
- [x] Adottato workflow `CLAUDE.md`/`pronostick_sicurezza.md` (comandi RIEPILOGO/REGISTRA/REVISIONA/VERIFICA-SICUREZZA/PATCH) + `scripts/check-known-bug-patterns.sh`
- [x] Sicurezza Firestore: regole di default violate trovate e corrette (invariante #5), sync verificato; corretti `logoutGoogle()` e escaping mancante in `renderCalendario()` (14/07/2026)
- [x] Model ID Anthropic deprecati sostituiti nel dropdown; `getWebSearchTool()` per upgrade condizionale web_search in base al modello (14/07/2026)
- [x] Filtro Data nello Storico + aggiornamento completo della Guida (nuova tab Altre Funzioni, FAQ modello corretta) (14/07/2026)
- [x] Code review completa (Sonnet 5, impegno alto) di `index.html`+`proxy.js` — 18 problemi trovati; risolti e verificati dal vivo tutti i 10 critici/sicurezza: A1 (bottoni Ricalcola/Elimina rotti + bug dormiente in `deleteEntry()`), A2 (dettaglio pronostico mai visibile), C2 (pannello Verifica che si richiudeva), B1-B5 (escaping mancante in 7 funzioni — chiude invariante #4), A3 (Enter rotto su 2 campi), A4 (`renderChips()` riscritta con DOM), A5 (svuota calendario non sincronizzato con Firebase) (14/07/2026)

---

## Bug Noti

> Emersi dalla code review completa (codice + UI) del 14/07/2026, con Sonnet 5 impegno alto. I bug risolti sono compressi in Archivio Log — dettaglio completo lì. Restano da programmare i minori (C1, C3-C7) e UI/UX (D1-D6), nessuno bloccante.

### Minori / incoerenze
- [ ] **C1** — Grafico ROI (`index.html:3772`) usa sempre `quota` (stimata), i KPI usano `quota_reale || quota` — possono divergere se l'utente ha inserito la quota reale.
- [ ] **C3** — `importo_giocato` salvato di default a 10 (`index.html:3032`, valore letto dal campo calcolatore che parte precompilato a 10) anche se l'utente non ha davvero puntato nulla → falsa il ROI reale nelle Statistiche.
- [ ] **C4** — Classe CSS `.apikey-card.configured` non si applica mai: l'elemento reale ha classe `settings-card` (verificato), il feedback visivo "key configurata" previsto dal CSS non scatta.
- [ ] **C5** — I loop `web_search` in `fetchWebData`, `cercaPartite`, `verificaRisultato`, `avviaGiocataConsigliata`/`runWithWebSearch` inviano `tool_result` fittizi scritti a mano ("Ricerca eseguita per...") — `web_search` è un tool lato server eseguito da Anthropic stesso, quindi quel ramo del loop è codice morto che non scatta mai nella pratica.
- [ ] **C6** — `console.log`/`console.warn` dimenticati in `toggleDetail()` (`index.html:4280`).
- [ ] **C7** — Codice morto: `handleCardClick()` mai chiamata, CSS duplicato/obsoleto (`.hcard-top`, `.btn-ricalcolo`, `.apikey-card`, doppia definizione `.hcard`, due media query `max-width:600px` identiche).

### UI / UX / Design
- [ ] **D1** — Nessun favicon (verificato: `<link rel="icon">` assente).
- [ ] **D2** — Tab bar fissa in basso senza `padding-bottom: env(safe-area-inset-bottom)` — su iPhone con home indicator la barra può risultare parzialmente coperta.
- [ ] **D3** — 3 link `target="_blank"` (billing, keys, billing) senza `rel="noopener"` (verificato).
- [ ] **D4** — Chart.js caricato da CDN esterno senza gestione fallback: se il CDN non risponde, la pagina Statistiche va in errore silenzioso.
- [ ] **D5** — Bottoni-icona (🗑, ✕, badge di stato) senza `aria-label`, poco accessibili con screen reader.
- [ ] **D6** — Il Backup esporta/importa solo lo storico pronostici, non il calendario partite salvate.

---

## Decisioni Prese
> Aggiorna ad ogni sessione. Serve a non ripercorrere strade già valutate. Le decisioni più vecchie/consolidate sono in Archivio Log.

| Data | Decisione | Motivazione |
|------|-----------|-------------|
| 14/07/2026 | Prima di iniziare l'aggiornamento della Guida, chiarito con Fabio lo scopo (aggiornamento leggero vs copertura completa) tramite domanda diretta invece di assumerlo | La task in `pronostick_stato.md` era descritta in modo ambiguo ("aggiornare con le nuove feature") — scelta la copertura completa (documentate anche Giocata, Calendario, Combinata, Backup, mai spiegate prima) |
| 14/07/2026 | `renderChips()` riscritta con DOM (`createElement`) invece di stringhe concatenate, per correggere insieme onclick troncato e nome file non escapato (bug A4) | Stessa causa doppia in un solo punto — la costruzione via DOM elimina strutturalmente sia il problema di escaping sia quello di interpolazione in un attributo, evitando un fix parziale |
| 14/07/2026 | In `buildMercatiConsigliati()`, la priorità del mercato è vincolata a whitelist (`alta`/`media`/`bassa`) invece di essere solo passata da `escapeHtml()` | Il valore finisce in un attributo `class` scritto senza apici — l'escaping HTML da solo non impedisce a un valore imprevisto di alterare il markup in quel contesto specifico |
| 14/07/2026 | PATCH applicata a `CLAUDE.md` (Principi di debug e architettura + Escaping HTML): aggiunta regola su test end-to-end di handler ripristinati + tecnica di verifica per fix di escaping (payload XSS su tutti i campi in un colpo) | Riabilitando il bottone Elimina (A1) è emerso un secondo bug dormiente mai capitato prima perché il codice non era mai stato raggiunto — nessuna regola esistente copriva questo caso |

---

## Alternative Scartate
> Idee o soluzioni valutate e abbandonate. Non riproporre senza nuovi elementi.

| Alternativa | Motivo scarto |
|-------------|---------------|
| Backend custom | Troppo complesso senza esperienza di programmazione |
| Sonnet come modello su Tier 1 | Rate limit più basso, passare solo da Tier 2 |
| Service Worker con blob URL | Crash Android confermato |

---

## Log Sessioni
> Le sessioni più vecchie sono in Archivio Log.

| Data | Attività |
|------|----------|
| 14/07/2026 | Code review completa (Sonnet 5, impegno alto) di `index.html`+`proxy.js`: 18 problemi trovati e categorizzati (5 critici, 5 sicurezza, 7 minori, 6 UI/UX). Corretti e verificati dal vivo in anteprima locale (click reali, DOM, payload XSS iniettato in tutti i campi sospetti) tutti i 10 bug critici/sicurezza: A1 (bottoni Ricalcola/Elimina rotti + bug dormiente scoperto in `deleteEntry()`), A2 (dettaglio pronostico mai visibile per classe CSS mancante), C2 (pannello Verifica che si richiudeva dopo il refresh), B1-B5 (escaping mancante in 7 funzioni di rendering — chiude invariante #4), A3 (Enter rotto su 2 campi per escape `\'` non valido), A4 (`renderChips()` riscritta con DOM), A5 (svuota calendario non sincronizzato con Firebase). Script pattern-trappola eseguito più volte (solo il solito falso positivo backtick), nessun errore console. Non eseguiti REVISIONA/VERIFICA-SICUREZZA formali (bugfix su funzionalità/invarianti esistenti, non nuove funzionalità). Eseguito REGISTRA: Fase 1 PATCH proposta e confermata (2 patch — test end-to-end di handler ripristinati + tecnica di verifica payload XSS per fix di escaping), poi Fase 2 con aggiornamento di tutti i `.md` e archiviazione delle sessioni/decisioni più vecchie per restare sotto le 150 righe. Restano aperti solo i bug minori (C1, C3-C7) e UI/UX (D1-D6), nessuno bloccante. |

## Archivio Log
> Sessioni e decisioni più vecchie, spostate qui il 14/07/2026 per restare sotto le 150 righe — dettaglio ridotto, il codice/git history restano la fonte primaria per i dettagli tecnici.

### Sessioni precedenti
- **25/04/2026** — Sviluppo iniziale: Cerca Quote, dropdown bookmaker, pannello quote collassabile, pulsante TUTTI i mercati.
- **14/07/2026** — Code review iniziale (5 bug corretti: precedenza operatori, apici vs backtick, escaping mancante) → adottato `CLAUDE.md`/`pronostick_sicurezza.md`, setup Claude Code (`.gitignore`, script pattern-trappola).
- **14/07/2026** — Sicurezza Firestore: regole di default violate trovate e corrette (invariante #5), sync verificato funzionalmente; corretti `logoutGoogle()` (non svuotava localStorage) ed escaping mancante in `renderCalendario()`.
- **14/07/2026** — Python/Node installati in locale + anteprima locale; sostituiti 2 model ID Anthropic deprecati nel dropdown; aggiunta `getWebSearchTool()` per upgrade condizionale web_search in base al modello.
- **14/07/2026** — Chiuse le task Filtro Data nello Storico e aggiornamento Guida (nuova tab Altre Funzioni, FAQ modello corretta).

### Decisioni precedenti
- **25/04/2026** — Proxy Netlify per API key, Firebase Firestore per sync, Haiku come modello su Tier 1, singolo file HTML inline (vedi Principi Prodotto in `CLAUDE.md`).
- **14/07/2026** — Adottato workflow `CLAUDE.md`/PATCH/REGISTRA (Fase 1 PATCH poi Fase 2 salvataggio, un solo commit); regole Firestore verificate via copia-incolla manuale (niente credenziali a Claude Code); Python+Node installati per anteprima locale prima del push.
- **14/07/2026** — PATCH applicate: escaping invariante #4 dichiarato non esaustivo (+ `renderCalendario()`); riverifica periodica model ID; chiarire scopo di task ambigue prima di iniziare una sessione.
- **14/07/2026** — Sostituiti solo i 2 model ID deprecati (opzione a minimo impatto tra 3 proposte); `getWebSearchTool()` deriva la variante dal modello già selezionato in Menu ⚙️, nessun nuovo controllo utente.

### Bug risolti (code review 14/07/2026 — dettaglio completo nel commit)
- **A1** `index.html:3143` — bottoni Ricalcola/Elimina chiamavano funzioni inesistenti, ricollegati a `ricalcola()`/`deleteEntry()`; trovato e corretto un secondo bug dormiente in `deleteEntry()` (`insertBefore` su nodo non figlio diretto).
- **A2** `index.html:4346` — dettaglio pronostico mai visibile, mancava la classe CSS `open`.
- **A3** `index.html:1714,1931` — escape `\'` non valido in 2 `onkeydown`, rompeva l'handler Enter.
- **A4** `index.html:2817` — `renderChips()` riscritta con DOM: risolve onclick troncato + nome file non escapato.
- **A5** `index.html:3365` — `clearCalendario()` ora sincronizza lo svuotamento su Firebase.
- **B1-B5** `renderStats()`, `renderCombinataResult()`, `renderResult()`, `buildFullDetailHTML()`, `buildMercatiConsigliati()`, `renderGiocataResult()`, `renderBiasPanel()` — escaping mancante aggiunto (invariante #4), verificato con payload XSS su tutti i campi.
- **C2** `index.html:4596` — pannello "Verifica Risultato" si richiudeva subito dopo il refresh, ora riapre la card.

---

## Note Tecniche
- index.html: singolo file ~4800+ righe, tutto inline
- Proxy Netlify timeout: 26s max (non aumentabile senza piano Pro)
- Non usare innerHTML per card DOM (preservare event listener)
- Attenzione virgolette singole in stringhe JS con HTML
- Python 3.12 e Node.js LTS installati in locale (14/07/2026) — server di anteprima disponibile con `.claude/launch.json` (`localhost:8080`), utile per testare modifiche prima del push
