# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 16/07/2026 |
| **Ultima sessione** | Controllo costi/ragionamento del punto di Verifica Risultato in Storico — trovato e corretto un bug reale di escaping mancante (XSS) in `verificaRisultato()`, aggiunta stima di costo prima assente |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata, nessun bug noto aperto. Sessione del 15/07/2026 (mattina): analisi (non implementazione) del metodo di generazione pronostici e del sistema di apprendimento da utilizzo (`buildPrompt`/`buildMemory`/verifica). Emersa una roadmap a 4 passi progressivi verso il Tag Pattern per AI Memory (vedi Task Aperte), attualmente bloccata sul primo gradino per mancanza di dati (2 pronostici verificati, servono almeno 5-6 per il primo passo).

Sessione del 15/07/2026 (pomeriggio): spostata la ricerca calendario (query web ampie, poco valore analitico) fuori dal budget API a pagamento di Pronostick, su un Project claude.ai dedicato che usa l'uso incluso nel piano Pro. Implementato il lato Pronostick: import calendario da incolla nella tab Calendario, con validazione esplicita riga per riga.

Sessione del 15/07/2026 (sera): consolidata la ricerca calendario dentro Claude Code (stesso piano Pro di Fabio, nessun costo aggiuntivo) invece del Project claude.ai separato — creata skill `.claude/skills/cerca-calendario/SKILL.md`, output su file locale `calendario/export.json` (gitignored). Aggiunto anche upload file diretto nella tab Calendario (accanto al copia-incolla), stessa validazione già esistente riusata. Primo test end-to-end con ricerca reale (Tennis ATP): trovati e corretti un nome giocatore inventato e una data sbagliata (letta da un riepilogo di ricerca aggregato) — nessuno dei due era intercettabile dalla sola validazione di formato. Patch applicate a `SKILL.md` (2) e `CLAUDE.md` (1, vedi sotto). Proposta di Fabio di un comando `!ricerca` per isolare le ricerche dalla chat di coding — discussa, in sospeso: prima verificare se la skill è già invocabile nativamente con `/cerca-calendario` in una sessione nuova, prima di costruire una convenzione ad hoc.

Sessione del 16/07/2026 (pomeriggio): confermato che `/cerca-calendario` è invocabile nativamente in una sessione Claude Code separata — task di verifica chiusa, nessun bisogno del fallback `!ricerca`. Fabio ha eseguito la prima ricerca reale (2 partite tennis trovate, calcio/basket correttamente vuoti per pausa estiva). Rivista la trascrizione di quella sessione con gli strumenti di gestione sessione (`list_sessions`/`list_events`) invece di farsela incollare: applicati bene i punti 5-6 della skill (niente dati inventati), e la sessione ha trovato/corretto da sola un bug prima di consegnare (wrapper `{"ricerche":[...]}` incompatibile col parser reale, scoperto verificando contro `index.html` come da procedura). Applicata patch a `SKILL.md` (v1.2): schema chiarito per il caso multi-sport in un'unica richiesta.

Sessione del 16/07/2026 (sera): Fabio ha chiesto di controllare costi e "ragionamento" nel punto di Verifica Risultato in Storico, e se allineato con le modifiche recenti. Analisi diretta del codice (`verificaRisultato()`, `buildMemory()`, `buildPrompt()`, pannello costi): il mapping campi tra schema JSON di analisi ed eval prompt è corretto, nessun disallineamento con le modifiche recenti (calendario, flusso separato). Trovato invece un bug reale non legato alle modifiche recenti: `verificaRisultato()` scriveva il pannello senza `escapeHtml()` su testo AI generato da un risultato di web search — non coperto dall'invariante #4, a differenza di `buildCompactCardDOM()` che ridisegna lo stesso pannello dai dati salvati correttamente escapato. Corretto e verificato iniettando payload XSS in tutti i campi (0 esecuzioni). Aggiunta anche una stima di costo (`~$0.10`) accanto al bottone, prima assente (2 chiamate API reali senza indicatore). REGISTRA eseguito: Fase 1 PATCH — 3 gap trovati e applicati (script di controllo pattern, procedura di verifica manuale dell'invariante #4, estensione Principio Prodotto #3).

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

---

## Bug Noti

Nessun bug noto aperto al momento (chiusi tutti in sessione del 14/07/2026 — vedi Log Sessioni). I bug risolti sono compressi in Archivio Log.

---

## Decisioni Prese
> Aggiorna ad ogni sessione. Serve a non ripercorrere strade già valutate. Le decisioni più vecchie/consolidate sono in Archivio Log.

| Data | Decisione | Motivazione |
|------|-----------|--------------|
| 15/07/2026 | Ricerca calendario partite spostata su un Project claude.ai esterno (uso incluso nel piano Pro) invece di restare sull'API a pagamento di Pronostick, con un meccanismo `!patch` leggero per evolvere le sue istruzioni nel tempo; Giocata resta invariata per ora perché nella sua chiamata 1 ricerca-partite e giudizio-pick sono fusi nella stessa chiamata web_search, non separabili senza ristrutturarla | Calendario è pura ricerca, swap 1:1 a basso rischio; non lecito usare l'abbonamento Pro come backend dell'API. Il `!patch` (Fabio ha corretto la proposta iniziale senza meccanismo di evoluzione) traccia i cambi (whitelist leghe, schema output) senza la piena governance REGISTRA, sproporzionata per un solo file di istruzioni senza dati persistenti |
| 15/07/2026 | L'import calendario (sia da incolla che da upload file, `importaCalendarioIncollato()`) riusa `saveCalendario()`/`renderCalendario()` esistenti invece di scrivere un percorso di parsing/render nuovo, e aggiunge validazione esplicita per campo con errori visibili per riga scartata | Riuso = zero nuova superficie XSS (l'escaping è già coperto lì). La validazione per campo chiude un gap notato da Fabio: il riuso delle funzioni garantiva solo la sicurezza del rendering, non la correttezza del contenuto incollato — vedi patch a CLAUDE.md (sezione Import/parsing dati esterni). L'upload file (15/07/2026) riusa al 100% la stessa validazione, unica differenza è la sorgente del testo |
| 15/07/2026 | Ricerca calendario spostata dal Project claude.ai esterno a una skill Claude Code locale (`.claude/skills/cerca-calendario/`), invece di mantenere i due canali paralleli | Fabio usa Claude Code sul piano Pro (stesso di claude.ai) — nessuna differenza di costo, ma un passaggio in meno e la possibilità per Claude Code di validare l'output contro il parser reale invece che contro una copia di documentazione. `pronostick_calendario_project.md` resta come alternativa, non eliminato |
| 16/07/2026 | Confermato che `/cerca-calendario` è invocabile nativamente in una sessione Claude Code nuova, senza bisogno del fallback `!ricerca` proposto da Fabio il 15/07 per isolare le ricerche dalla chat di coding | Verificato con un primo uso reale: la skill è stata trovata e lanciata correttamente dalla sessione dedicata, chiude la task aperta di verifica |
| 16/07/2026 | Applicate 3 patch da un controllo diretto del punto di Verifica Risultato: nuovo controllo [5] in `check-known-bug-patterns.sh` (blocchi `innerHTML=` per concatenazione senza `escapeHtml()`), nota in `CLAUDE.md` sul grep manuale `.innerHTML` per l'invariante #4 (path di rendering duplicati possono divergere), estensione Principio Prodotto #3 a ogni bottone che chiama l'API | Il bug reale trovato (escaping mancante in `verificaRisultato()`) non era intercettabile né dallo script esistente (solo pattern template-literal) né dal principio costi (limitato al pannello di Analizza) — gap strutturali, non solo un fix puntuale |

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
| 16/07/2026 | Fabio ha eseguito la prima ricerca calendario reale con `/cerca-calendario` in una sessione Claude Code separata — confermata l'invocazione nativa, chiusa la task di verifica, nessun bisogno di `!ricerca`. Trovate 2 partite tennis (Pellegrino-Rublev, Arnaldi-Dzumhur), calcio e basket correttamente vuoti (pausa estiva/dati non confermati, nessun dato forzato). Rivista la trascrizione della sessione con gli strumenti di gestione sessione (`list_sessions`/`list_events`) invece di farsela incollare da Fabio: applicati bene i punti 5-6 della skill (niente fabbricazioni), e la sessione ha trovato/corretto da sola un bug prima di consegnare — un wrapper `{"ricerche":[...]}` incompatibile col parser reale (`importaCalendarioIncollato()` si aspetta `partite` a livello radice), scoperto verificando contro `index.html` come richiesto dalla procedura. Applicata patch a `SKILL.md` (v1.2): schema output chiarito per il caso di più sport in un'unica richiesta. REGISTRA eseguito: Fase 1 PATCH — nessun gap per CLAUDE.md, la patch riguardava solo SKILL.md. Compresse in Archivio Log le voci più vecchie (14/07/2026) di Decisioni Prese e Log Sessioni per restare sotto le 150 righe. |
| 16/07/2026 | Fabio ha chiesto di controllare costi e "ragionamento" nel punto di Verifica Risultato in Storico, e se allineato con le modifiche recenti. Letti `verificaRisultato()`, `buildMemory()`, `buildPrompt()`, mapping campi al salvataggio: nessun disallineamento trovato lì. Trovato invece un bug di escaping mancante (XSS) in `verificaRisultato()`, non coperto dall'invariante #4 — corretto e verificato con payload XSS in tutti i campi (0 esecuzioni), più una stima di costo `~$0.10` prima assente sul bottone. Testato in anteprima locale (server statico, dati di test in localStorage). REGISTRA eseguito: Fase 1 PATCH — 3 gap trovati e applicati (vedi Decisioni Prese, CLAUDE.md, `check-known-bug-patterns.sh`). Compresse in Archivio Log le 3 voci di sessione del 15/07/2026 per restare sotto le 150 righe. |

## Archivio Log
> Sessioni e decisioni più vecchie, spostate qui il 14/07/2026 per restare sotto le 150 righe — dettaglio ridotto, il codice/git history restano la fonte primaria per i dettagli tecnici.

### Sessioni precedenti
- **25/04/2026** — Sviluppo iniziale: Cerca Quote, dropdown bookmaker, pannello quote collassabile, pulsante TUTTI i mercati.
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

### Bug risolti (code review 14/07/2026 — dettaglio completo nel commit)
- **A1** bottoni Ricalcola/Elimina ricollegati a `ricalcola()`/`deleteEntry()`; corretto bug dormiente in `deleteEntry()` (`insertBefore` su nodo non figlio diretto).
- **A2** dettaglio pronostico mai visibile, mancava la classe CSS `open`.
- **A3** escape `\'` non valido in 2 `onkeydown`, rompeva l'handler Enter.
- **A4** `renderChips()` riscritta con DOM.
- **A5** `clearCalendario()` ora sincronizza lo svuotamento su Firebase.
- **B1-B5** escaping mancante aggiunto in 7 funzioni di rendering (invariante #4).
- **C2** pannello "Verifica Risultato" si richiudeva subito dopo il refresh, ora riapre la card.

---

## Note Tecniche
- index.html: singolo file ~4900 righe, tutto inline
- Proxy Netlify timeout: 26s max (non aumentabile senza piano Pro)
- Non usare innerHTML per card DOM (preservare event listener)
- Attenzione virgolette singole in stringhe JS con HTML
- Python 3.12 e Node.js LTS installati in locale (14/07/2026) — server di anteprima disponibile con `.claude/launch.json` (`localhost:8080`), utile per testare modifiche prima del push
- Il tool di lettura file di Claude Code può mostrare `<\div>`/`<\span>` invece di `</div>`/`</span>` nel suo output per righe molto lunghe — è un artefatto di visualizzazione, non il contenuto reale del file. Verificare sempre con grep sul file prima di considerarlo un bug (falso allarme scoperto 14/07/2026)
