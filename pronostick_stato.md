# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 20/08/2026 |
| **Ultima sessione** | Passo 3 — collegamento al meccanismo di manutenzione dei template: campo `AMBITO` nel comando PATCH, deposito patch universali in REGISTRA, blocco Allineamento al template (baseline 19/08/2026). Nessun bug, nessuna nuova funzionalità |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata, nessun bug noto aperto. Roadmap Memoria AI (vedi Task Aperte) ancora ferma al primo gradino per mancanza di dati (pochi pronostici verificati). Dettaglio delle sessioni 15-16/07/2026 (ricerca calendario, fix escaping Verifica Risultato) in Log Sessioni/Archivio Log sotto.

**Pronostick.Code** (`Pronostick.Code/`, avviato 26/07/2026): motore satellite di analisi/verifica pronostici via Claude Code (WebSearch nativo) invece che API a pagamento, isolato dal Pronostick reale, usato da Fabio con soldi reali (KPI/ROI in `dashboard.html`). Sessioni 1-3 completate, primo pronostico reale verificato VINTO (28/07/2026) — dettaglio in Archivio Log/Decisioni Prese. Resta solo il test a mano del selettore di cartella nativo (vedi Task Aperte). **Novità 20/08/2026:** eseguito il Passo 3 — Pronostick collegato al meccanismo di manutenzione dei template (campo `AMBITO`, deposito patch, blocco Allineamento) — vedi `CLAUDE.md`.

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
- [x] Code review completa (Sonnet 5, impegno alto) — 18 problemi trovati; risolti i 10 critici/sicurezza (A1-A5, B1-B5), chiude invariante #4 escaping (14/07/2026)
- [x] Filtro Data nello Storico + aggiornamento completo della Guida; model ID Anthropic deprecati sostituiti; `getWebSearchTool()` per upgrade condizionale (14/07/2026)
- [x] Chiusi tutti i 13 bug minori/UI rimasti dalla code review: C1 (grafico ROI usa quota_reale), C3 (importo_giocato non più precompilato a 10), C4 (feedback visivo "key configurata" ripristinato), C5 (rimossi 4 rami web_search morti mai eseguiti — semplificate a singola chiamata), C6 (console.log rimossi), C7 (rimossa `handleCardClick()` morta + CSS duplicato/obsoleto: `.apikey-card`, `.hcard-top` e famiglia, `.btn-ricalcolo`, doppia `.hcard`, media query duplicate), D1 (favicon 🎯 via data-URI), D2 (safe-area-inset-bottom su tab bar), D3 (`rel="noopener"` su 3 link esterni), D4 (fallback se Chart.js CDN non risponde), D5 (aria-label su bottoni-icona), D6 (Backup ora include anche il calendario partite, import retrocompatibile con backup vecchi) (14/07/2026)
- [x] Import Calendario da incolla (tab Calendario) + istruzioni Project claude.ai esterno dedicato alla ricerca partite, per spostare le query web ampie fuori dal budget API a pagamento (15/07/2026)
- [x] Ricerca calendario consolidata dentro Claude Code: skill `.claude/skills/cerca-calendario/SKILL.md` + output su file locale `calendario/export.json` + upload file diretto in tab Calendario (riusa validazione esistente) — testato end-to-end con ricerca reale, 2 bug trovati e corretti (15/07/2026)
- [x] Confermato che `/cerca-calendario` è invocabile nativamente in una sessione Claude Code separata — prima ricerca reale eseguita con successo, patch v1.2 a `SKILL.md` per il caso multi-sport (16/07/2026)
- [x] Corretto escaping mancante in `verificaRisultato()` (XSS via testo AI generato da web search, non coperto dall'invariante #4) + aggiunta stima di costo `~$0.10` prima assente sul bottone Verifica Risultato; nuovo controllo euristico [5] in `check-known-bug-patterns.sh` (16/07/2026)
- [x] Pronostick.Code — Sessioni 1-3 (fondamenta, dashboard, guida/FAQ poi unificata) + skill `analizza-locale` + prima analisi reale Musetti vs Arnaldi + tracciamento soldi reali — dettaglio in Archivio Log (26/07/2026)
- [x] Passo 3 — collegamento al meccanismo di manutenzione dei template: campo `AMBITO` nel comando PATCH, deposito patch verso `Template Claude\patch\_inbox\` in REGISTRA Fase 1, blocco `## Allineamento al template` (baseline 19/08/2026, `Travasi recepiti: U-001`) in `CLAUDE.md` (20/08/2026)

---

## Bug Noti

Nessun bug noto aperto al momento (chiusi tutti in sessione del 14/07/2026 — vedi Log Sessioni). I bug risolti sono compressi in Archivio Log.

---

## Decisioni Prese
> Aggiorna ad ogni sessione. Serve a non ripercorrere strade già valutate. Le decisioni più vecchie/consolidate sono in Archivio Log.

| Data | Decisione | Motivazione |
|------|-----------|--------------|
| 15/07/2026 | Ricerca calendario spostata dal Project claude.ai esterno a una skill Claude Code locale (`.claude/skills/cerca-calendario/`), invece di mantenere i due canali paralleli | Fabio usa Claude Code sul piano Pro (stesso di claude.ai) — nessuna differenza di costo, ma un passaggio in meno e la possibilità per Claude Code di validare l'output contro il parser reale invece che contro una copia di documentazione. `pronostick_calendario_project.md` resta come alternativa, non eliminato |
| 16/07/2026 | Confermato che `/cerca-calendario` è invocabile nativamente in una sessione Claude Code nuova, senza bisogno del fallback `!ricerca` proposto da Fabio il 15/07 per isolare le ricerche dalla chat di coding | Verificato con un primo uso reale: la skill è stata trovata e lanciata correttamente dalla sessione dedicata, chiude la task aperta di verifica |
| 16/07/2026 | Applicate 3 patch da un controllo diretto del punto di Verifica Risultato: nuovo controllo [5] in `check-known-bug-patterns.sh` (blocchi `innerHTML=` per concatenazione senza `escapeHtml()`), nota in `CLAUDE.md` sul grep manuale `.innerHTML` per l'invariante #4 (path di rendering duplicati possono divergere), estensione Principio Prodotto #3 a ogni bottone che chiama l'API | Il bug reale trovato (escaping mancante in `verificaRisultato()`) non era intercettabile né dallo script esistente (solo pattern template-literal) né dal principio costi (limitato al pannello di Analizza) — gap strutturali, non solo un fix puntuale |
| 26/07/2026 | Avviato progetto satellite separato **Pronostick.Code** (scartata un'estensione ibrida dentro `index.html` per rischio architetturale) — motore Claude Code invece di API, dati isolati su file locali, verifica anch'essa via Claude Code, travaso miglioramenti verso il Pronostick reale sempre manuale. Sessione 2 (dashboard) costruita prima della verifica del test (rischio accettato, scelta esplicita di Fabio). Aggiunto tracciamento soldi reali (`importo_giocato`/`quota_reale`/KPI/ROI, compilati solo da Fabio in dashboard) dopo che Fabio ha chiarito di usarlo con soldi veri, non solo come laboratorio. Poi unificate `dashboard.html`/`istruzioni.html` in un'unica pagina | Fabio vuole affinare il ragionamento a costo zero (piano Pro) prima di spendere credito API — stesso pattern del progetto gemello Bracco. Dettaglio completo in Archivio Log/Log Sessioni 26/07 |
| 26/07/2026 | 2 patch a `CLAUDE.md`: Gestione modello (chiedere sempre il modello/impegno attuale prima di proporre un'escalation) e Definizione "funzionalità completata" (dialoghi nativi del SO vanno sempre testati a mano) | Due gap reali trovati nella sessione: escalation proposta quando Fabio aveva già quel livello; automazione browser non può interagire col selettore di cartella nativo |
| 20/08/2026 | Eseguito il Passo 3 (`Template Claude\docs\passo3_collegamento_progetti.md`): aggiunto campo `AMBITO` al comando PATCH, passo di deposito patch universali in `patch/_inbox/` durante REGISTRA Fase 1, blocco di allineamento con baseline 19/08/2026 (`Travasi recepiti: U-001`) | Pronostick era antecedente al meccanismo di manutenzione dei template — senza questo collegamento una lezione universale trovata qui restava intrappolata nel `CLAUDE.md` locale invece di raggiungere gli altri progetti |

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
| 20/08/2026 | Eseguito RIEPILOGO, poi il Passo 3 di collegamento ai template (`passo3_collegamento_progetti.md`, eseguito dentro Pronostick, non dentro Template Claude): verificato il prerequisito (percorso `Template Claude\patch\_inbox\` esistente), inseriti i 3 elementi in `CLAUDE.md` (campo `AMBITO` nel comando PATCH, deposito patch in REGISTRA Fase 1, blocco Allineamento al template), verificati con grep, commit `3a74337`. Nessun file di Template Claude toccato. REGISTRA eseguito: Fase 1 nessuna PATCH non banale emersa (sessione a spec fissa, nessuna deviazione); compressa in Archivio Log la voce del 28/07/2026 per rientrare nel limite di 150 righe. |

## Archivio Log
> Sessioni e decisioni più vecchie, spostate qui il 14-26/07/2026 per restare sotto le 150 righe — dettaglio ridotto, il codice/git history restano la fonte primaria per i dettagli tecnici.

### Sessioni precedenti
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
