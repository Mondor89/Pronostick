# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 25/08/2026 |
| **Ultima sessione** | RECEPISCI di 12 travasi pendenti (U-022–U-033) in `CLAUDE.md`, con audit indipendente (sotto-agente Opus 5) prima di scrivere; 2 casi di debito di baseline colmati su scelta esplicita di Fabio (U-023, U-027), 3 valutati non applicabili allo stack (verificato su Pronostick e Pronostick.Code). PATCH applicata: verifica di applicabilità deve coprire entrambe le basi di codice, non solo il Pronostick reale |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata, nessun bug noto aperto. Roadmap Memoria AI (vedi Task Aperte) ancora ferma al primo gradino per mancanza di dati (pochi pronostici verificati). Dettaglio delle sessioni 15-16/07/2026 (ricerca calendario, fix escaping Verifica Risultato) in Log Sessioni/Archivio Log sotto.

**Pronostick.Code** (`Pronostick.Code/`, avviato 26/07/2026): motore satellite di analisi/verifica pronostici via Claude Code (WebSearch nativo) invece che API a pagamento, isolato dal Pronostick reale, usato da Fabio con soldi reali (KPI/ROI in `dashboard.html`). Sessioni 1-3 completate, primo pronostico reale verificato VINTO (28/07/2026) — dettaglio in Archivio Log/Decisioni Prese. Resta solo il test a mano del selettore di cartella nativo (vedi Task Aperte). **Novità 25/08/2026:** ora esplicitamente coperto dalla verifica di applicabilità dei travasi/pattern-trappola, non solo il Pronostick reale — vedi `CLAUDE.md`.

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

### Pronostick.Code — roadmap (avviato 26/07/2026)
- [ ] **Test a mano del flusso reale di `dashboard.html`** — selettore cartella nativo (File System Access API, lettura/scrittura), campi Importo/Quota editabili, salvataggio su file: non automatizzabile da browser, va fatto da Fabio
- [x] Sessioni 2-3 (dashboard, guida unificata, tracciamento soldi reali) e verifica del primo pronostico reale (Musetti vs Arnaldi, VINTO, 28/07/2026) — dettaglio in Archivio Log/Decisioni Prese

### Priorità Alta — roadmap Memoria AI (analisi 15/07/2026, in ordine di esecuzione)
- [ ] Spot-check affidabilità della verifica automatica (confrontare a mano 5-6 `verifica.nota_apprendimento` col risultato reale) — appena si arriva a 5-6 pronostici verificati. Prerequisito: oggi (15/07/2026) la pipeline di verifica (auto-giudizio AI su web search) non è mai stata validata contro un riscontro umano
- [ ] Estendere la verifica ai singoli mercati (oggi giudica solo `pronostico_principale`, non i mercati Over/Under/1X2/GG in `entry.mercati`) — da fare PRIMA di qualsiasi statistica per-mercato, altrimenti quel dato resta incalcolabile
- [ ] Statistiche di calibrazione aggregate nel prompt (bucket confidenza + bias per sport/mercato, riusando i dati già in `renderStats()`/`renderBiasPanel()` invece delle sole 8 "lezioni" testuali di `buildMemory()`) — quando si arriva a ~15-20 pronostici verificati. Alternativa più semplice al Tag Pattern, da provare prima
- [ ] Sistema Tag Pattern completo per AI Memory — con 30+ pronostici verificati, **solo se** il passo sopra si rivela insufficiente
- [ ] Upgrade modello a Sonnet quando Tier 2 (≥$40 spesi)

### Priorità Bassa
- [ ] Rivedere a mano le ~15 righe segnalate dal nuovo controllo [5] di `check-known-bug-patterns.sh` (blocchi `innerHTML=` senza `escapeHtml()` nelle vicinanze) — probabili falsi positivi (es. `innerHTML=''` per svuotare un contenitore), ma non ancora verificate una per una

---

## Task Completate
> Le voci più vecchie/dettagliate sono compresse in Archivio Log.
- [x] App web single-page completa con 6 tab (Analizza, Giocata, Calendario, Storico, Guida, Menu)
- [x] Integrazione Anthropic API via proxy Netlify, Firebase Firestore (sync) + Google Auth
- [x] Dropdown 16 sport + mercati dinamici + pannello costi + Cerca Quote + AI Memory
- [x] Cartella locale collegata al repo GitHub — Claude Code committa/pusha direttamente; Python+Node installati in locale per anteprima prima del push (`.claude/launch.json`, `localhost:8080`)
- [x] Adottato workflow `CLAUDE.md`/`pronostick_sicurezza.md` (comandi RIEPILOGO/REGISTRA/REVISIONA/VERIFICA-SICUREZZA/PATCH) + `scripts/check-known-bug-patterns.sh`
- [x] 14-16/07/2026 — Code review completa (18 problemi: 10 critici/sicurezza + 13 minori/UI, tutti risolti, chiude invariante #4 escaping), Filtro Data Storico, Import/ricerca Calendario (incolla + skill `cerca-calendario`), fix escaping `verificaRisultato()` — dettaglio in Archivio Log/Sessioni precedenti
- [x] Pronostick.Code — Sessioni 1-3 (fondamenta, dashboard, guida/FAQ poi unificata) + skill `analizza-locale` + prima analisi reale Musetti vs Arnaldi + tracciamento soldi reali — dettaglio in Archivio Log (26/07/2026)
- [x] Passo 3 — collegamento al meccanismo di manutenzione dei template: campo `AMBITO` nel comando PATCH, deposito patch verso `Template Claude\patch\_inbox\` in REGISTRA Fase 1, blocco `## Allineamento al template` (baseline 19/08/2026, `Travasi recepiti: U-001`) in `CLAUDE.md` (20/08/2026)
- [x] Recepiti i 7 travasi pendenti dal registro (U-003, U-016–U-021): controlli Gestione modello, sezione sotto-agenti, controllo rimandi interni, riga Stato Attuale sempre aggiornata, pattern `.env`/dotenv — `Travasi recepiti` aggiornato in `CLAUDE.md` (22/08/2026)
- [x] RECEPISCI dei 12 travasi successivi (U-022–U-033): audit pre-scrittura via sotto-agente (Opus 5) su richiesta di Fabio, 2 casi di debito di baseline colmati (U-023 frase "Ambito della regola", U-027 nuova sezione su evolvere in versione online), 3 valutati non applicabili (U-025/U-029/U-030 — nessun server locale con validazione Origin, nessuna richiesta di rete verso URL utente, nessun comando di sistema esterno, verificato su entrambe le basi di codice), 1 bug reale trovato e documentato (`setTimeout` in `index.html:2780`, vedi Bug Noti). PATCH applicata: la verifica di applicabilità di un travaso deve coprire anche `Pronostick.Code/dashboard.html`, non solo il Pronostick reale (25/08/2026)

---

## Bug Noti

- [ ] `setTimeout(initGiocataSports, 50)` in `index.html:2780` — attesa fissa invece del segnale reale di readiness (`DOMContentLoaded` o ordine di caricamento script). Funziona quasi sempre, non ha mai dato problemi osservati — trovato per applicazione di U-033 (25/08/2026), non ancora corretto, priorità bassa.

I bug precedenti sono compressi in Archivio Log (chiusi tutti in sessione del 14/07/2026).

---

## Decisioni Prese
> Aggiorna ad ogni sessione. Serve a non ripercorrere strade già valutate. Le decisioni più vecchie/consolidate sono in Archivio Log.

| Data | Decisione | Motivazione |
|------|-----------|--------------|
| 26/07/2026 | Avviato progetto satellite separato **Pronostick.Code** (scartata un'estensione ibrida dentro `index.html` per rischio architetturale) — motore Claude Code invece di API, dati isolati su file locali, verifica anch'essa via Claude Code, travaso miglioramenti verso il Pronostick reale sempre manuale. Sessione 2 (dashboard) costruita prima della verifica del test (rischio accettato, scelta esplicita di Fabio). Aggiunto tracciamento soldi reali (`importo_giocato`/`quota_reale`/KPI/ROI, compilati solo da Fabio in dashboard) dopo che Fabio ha chiarito di usarlo con soldi veri, non solo come laboratorio. Poi unificate `dashboard.html`/`istruzioni.html` in un'unica pagina | Fabio vuole affinare il ragionamento a costo zero (piano Pro) prima di spendere credito API — stesso pattern del progetto gemello Bracco. Dettaglio completo in Archivio Log/Log Sessioni 26/07 |
| 26/07/2026 | 2 patch a `CLAUDE.md`: Gestione modello (chiedere sempre il modello/impegno attuale prima di proporre un'escalation) e Definizione "funzionalità completata" (dialoghi nativi del SO vanno sempre testati a mano) | Due gap reali trovati nella sessione: escalation proposta quando Fabio aveva già quel livello; automazione browser non può interagire col selettore di cartella nativo |
| 20/08/2026 | Eseguito il Passo 3 (`Template Claude\docs\passo3_collegamento_progetti.md`): aggiunto campo `AMBITO` al comando PATCH, passo di deposito patch universali in `patch/_inbox/` durante REGISTRA Fase 1, blocco di allineamento con baseline 19/08/2026 (`Travasi recepiti: U-001`) | Pronostick era antecedente al meccanismo di manutenzione dei template — senza questo collegamento una lezione universale trovata qui restava intrappolata nel `CLAUDE.md` locale invece di raggiungere gli altri progetti |
| 22/08/2026 | Recepiti i 7 travasi pendenti (U-003, U-016–U-021) invece di aspettare una sessione dedicata futura; nessuno introduceva conflitti con le regole esistenti | Fabio ha chiesto esplicitamente "recepisci"; il confronto per ID (non per testo) contro il registro non lasciava ambiguità sul cosa applicare |
| 25/08/2026 | Recepiti i 12 travasi successivi (U-022–U-033), inclusi 2 casi di debito di baseline (U-023, U-027) applicati per scelta esplicita di Fabio invece di essere saltati | L'audit pre-scrittura (sotto-agente Opus 5, richiesto da Fabio dato il batch di patch su sezioni condivise) ha trovato correzioni sostanziali su quasi tutti i punti — confermato che vale la pena farlo prima di scrivere, non solo a lavoro fatto |

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
| 25/08/2026 | RIEPILOGO, poi RECEPISCI dei 12 travasi pendenti (U-022–U-033) in `CLAUDE.md`: audit pre-scrittura via sotto-agente Opus 5 (batch su sezioni condivise), 2 debiti di baseline colmati su scelta di Fabio (U-023, U-027), 3 non applicabili verificati su Pronostick + Pronostick.Code (U-025/029/030), 1 istanza di bug reale citata (`setTimeout` in `index.html:2780`). REGISTRA: Fase 1 trovata 1 PATCH (la verifica di applicabilità di un travaso deve coprire entrambe le basi di codice, non solo `index.html`/`proxy.js` — emerso da una domanda diretta di Fabio), applicata a `CLAUDE.md`; compressa in Archivio Log la voce del 22/08/2026. |

## Archivio Log
> Sessioni e decisioni più vecchie, spostate qui il 14-26/07/2026 per restare sotto le 150 righe — dettaglio ridotto, il codice/git history restano la fonte primaria per i dettagli tecnici.

### Sessioni precedenti
- **22/08/2026** — Recepiti i 7 travasi pendenti dal registro template (U-003, U-016–U-021) in `CLAUDE.md`: controlli Gestione modello (apertura sessione, timing de-escalation, audit post-escalation), sezione sotto-agenti, controllo rimandi interni, riga Stato Attuale sempre aggiornata, pattern `.env`/dotenv. Commit `1a34646`, push. REGISTRA: Fase 1 trovata 1 PATCH non banale (gap del meccanismo travasi su baseline non integrale — due travasi presupponevano una sezione mai ricevuta), applicata a `CLAUDE.md` e depositata in `patch/_inbox/` (`AMBITO: da portare nel template`).
- **20/08/2026** — Passo 3: collegamento al meccanismo di manutenzione dei template (campo `AMBITO` nel comando PATCH, deposito patch in REGISTRA Fase 1, blocco Allineamento al template, baseline 19/08/2026, `Travasi recepiti: U-001`), commit `3a74337`.
- **28/07/2026** — Verificato il primo pronostico reale di Pronostick.Code (Musetti vs Arnaldi, VINTO). Lezione: la quota di mercato (1.36) più accurata della stima interna (60% vs ~73% implicito).
- **26/07/2026** — Avviato **Pronostick.Code** (satellite separato e reversibile invece di un'estensione ibrida di `index.html`, scartata per rischio architetturale): Sessione 1 fondamenta (`Pronostick.Code/`, skill `analizza-locale`), prima analisi reale (Musetti vs Arnaldi), Sessione 2 dashboard, Sessione 3 guida/FAQ (poi unificata con la dashboard), tracciamento soldi reali (`importo_giocato`/`quota_reale`/KPI/ROI). Patch a `CLAUDE.md` (Gestione modello — chiedere sempre il modello/impegno attuale prima di proporre un cambio).
- **25/04/2026** — Sviluppo iniziale: Cerca Quote, dropdown bookmaker, pannello quote collassabile, pulsante TUTTI i mercati.
- **16/07/2026** — Prima ricerca calendario reale con `/cerca-calendario` in sessione separata: invocazione nativa confermata, 2 partite tennis trovate, trovato/corretto un bug (wrapper incompatibile col parser) prima di consegnare. Patch `SKILL.md` v1.2 (schema multi-sport).
- **16/07/2026** — Controllo costi/ragionamento del punto Verifica Risultato: nessun disallineamento nel mapping campi, ma trovato e corretto un bug reale di escaping mancante (XSS) in `verificaRisultato()`, non coperto dall'invariante #4. Aggiunta stima di costo `~$0.10` prima assente sul bottone.
- **15/07/2026** — Analisi (nessun codice toccato) del metodo AI pronostici/apprendimento: statistiche aggregate mai riusate nel prompt, verifica limitata al solo pronostico principale, pipeline di auto-verifica mai validata contro riscontro umano. Definita roadmap a 4 step gated da soglie dati verso Tag Pattern.
- **15/07/2026** — Import Calendario da incolla (tab Calendario) + `pronostick_calendario_project.md` per Project claude.ai esterno dedicato alla ricerca partite, fuori dal budget API a pagamento.
- **15/07/2026** — Ricerca calendario consolidata dentro Claude Code: skill `.claude/skills/cerca-calendario/SKILL.md` + upload file diretto in tab Calendario. Primo test reale trovò 2 errori (nome giocatore inventato, data sbagliata) non intercettabili dalla sola validazione di formato.
- **14/07/2026** — Code review iniziale (5 bug corretti: precedenza operatori, apici vs backtick, escaping mancante) → adottato `CLAUDE.md`/`pronostick_sicurezza.md`, setup Claude Code (`.gitignore`, script pattern-trappola).
- **14/07/2026** — Sicurezza Firestore: regole di default violate trovate e corrette (invariante #5), sync verificato funzionalmente; corretti `logoutGoogle()` ed escaping mancante in `renderCalendario()`.
- **14/07/2026** — Python/Node installati in locale + anteprima locale; sostituiti 2 model ID Anthropic deprecati nel dropdown; aggiunta `getWebSearchTool()` per upgrade condizionale web_search in base al modello.
- **14/07/2026** — Chiuse le task Filtro Data nello Storico e aggiornamento Guida (nuova tab Altre Funzioni, FAQ modello corretta).
- **14/07/2026** — Code review completa (Sonnet 5, impegno alto): 18 problemi trovati (5 critici, 5 sicurezza, 7 minori, 6 UI/UX). Risolti e verificati i 10 critici/sicurezza: A1 (bottoni Ricalcola/Elimina rotti + bug dormiente in `deleteEntry()`), A2 (dettaglio pronostico mai visibile), C2 (pannello Verifica che si richiudeva), B1-B5 (escaping mancante in 7 funzioni — chiude invariante #4), A3 (Enter rotto), A4 (`renderChips()` riscritta con DOM), A5 (svuota calendario sincronizzato con Firebase). PATCH applicata: test end-to-end di handler ripristinati + tecnica payload XSS per fix di escaping.
- **14/07/2026** — Chiusura dei 13 bug minori/UI trovati dalla code review dello stesso giorno (C1, C3-C7, D1-D6): grafico ROI, importo giocata, feedback API key, codice/CSS morto, favicon, safe-area tab bar, `rel=noopener`, fallback Chart.js, aria-label, backup esteso al calendario. Autorizzata da Fabio in un'unica sessione nonostante il limite di complessità.

### Decisioni precedenti
- **25/04/2026** — Proxy Netlify per API key, Firebase Firestore per sync, Haiku come modello su Tier 1, singolo file HTML inline (vedi Principi Prodotto in `CLAUDE.md`).
- **14/07/2026** — Adottato workflow `CLAUDE.md`/PATCH/REGISTRA; regole Firestore verificate via copia-incolla manuale (niente credenziali a Claude Code); Python+Node installati per anteprima locale prima del push.
- **14/07/2026** — PATCH applicate: escaping invariante #4 dichiarato non esaustivo (+ `renderCalendario()`); riverifica periodica model ID; chiarire scopo di task ambigue prima di iniziare una sessione.
- **14/07/2026** — `renderChips()` riscritta con DOM invece di stringhe concatenate (corregge onclick troncato e nome file non escapato in un colpo); priorità mercato vincolata a whitelist invece di solo escapata (finiva in un attributo `class` senza apici).
- **14/07/2026** — Autorizzata sessione bug-fix multipla (13 bug in un colpo) nonostante il limite di complessità, chiesto esplicitamente con AskUserQuestion; C3: rimosso il precompilato "10" dall'importo giocata invece di un checkbox dedicato; C4: CSS legato all'id reale `#apikeyCard` invece di rinominare la card (`.apikey-card` era già CSS morto, rimosso nello stesso giro).
- **15/07/2026** — Prima del Tag Pattern per AI Memory, roadmap a 4 step progressivi (spot-check verifica → verifica per-mercato → statistiche di calibrazione aggregate → Tag Pattern), gated da soglie di pronostici verificati — vedi Task Aperte.
- **15/07/2026** — Ricerca calendario spostata su Project claude.ai esterno (poi su skill locale, vedi sopra) invece dell'API a pagamento; import calendario (`importaCalendarioIncollato()`) riusa `saveCalendario()`/`renderCalendario()` esistenti + validazione esplicita per campo con righe scartate visibili.

> Bug risolti dalla code review 14/07/2026 (A1-A5, B1-B5, C2) — dettaglio completo nella voce "Sessioni precedenti" sopra e nel commit.

---

## Note Tecniche
- index.html: singolo file ~4900 righe, tutto inline
- Proxy Netlify timeout: 26s max (non aumentabile senza piano Pro)
- Non usare innerHTML per card DOM (preservare event listener)
- Attenzione virgolette singole in stringhe JS con HTML
- Python 3.12 e Node.js LTS installati in locale (14/07/2026) — server di anteprima disponibile con `.claude/launch.json` (`localhost:8080`), utile per testare modifiche prima del push
- Il tool di lettura file di Claude Code può mostrare `<\div>`/`<\span>` invece di `</div>`/`</span>` nel suo output per righe molto lunghe — è un artefatto di visualizzazione, non il contenuto reale del file. Verificare sempre con grep sul file prima di considerarlo un bug (falso allarme scoperto 14/07/2026)
