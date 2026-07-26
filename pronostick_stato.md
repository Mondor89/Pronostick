# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 26/07/2026 |
| **Ultima sessione** | Pronostick.Code: tracciamento soldi reali in `dashboard.html` (importo_giocato/quota_reale/KPI/ROI) + unificazione dashboard.html/istruzioni.html in un'unica pagina (istruzioni.html eliminato) — resta solo la verifica end-to-end del test Musetti-Arnaldi (partita 27/07/2026) |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata, nessun bug noto aperto. Roadmap Memoria AI (vedi Task Aperte) ancora ferma al primo gradino per mancanza di dati (pochi pronostici verificati). Dettaglio delle sessioni 15-16/07/2026 (ricerca calendario, fix escaping Verifica Risultato) in Log Sessioni/Archivio Log sotto.

**Novità 26/07/2026** — avviato un progetto satellite separato, **Pronostick.Code** (`Pronostick.Code/`): motore di analisi/verifica pronostici via Claude Code (WebSearch nativo) invece che API a pagamento, isolato dal Pronostick reale (nessun collegamento a `index.html`/localStorage/Firestore), zero costo. Nasce per affinare il ragionamento di analisi senza spendere credito ad ogni iterazione — vedi sezione dedicata in `CLAUDE.md` per confini e motivazione. Sessioni 1-3 (fondamenta, dashboard, guida/FAQ) tutte completate. Chiarito in giornata che non è solo un laboratorio: Fabio lo usa con soldi reali come il Pronostick vero, quindi `dashboard.html` ora traccia importo/quota/KPI/ROI reali; `dashboard.html` e `istruzioni.html` sono stati poi unificati in un'unica pagina (istruzioni.html eliminato). Resta solo la verifica del primo test end-to-end (vedi Task Aperte).

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
- [ ] **Verifica del primo test end-to-end** — analisi già fatta (`2026-07-27_musetti-vs-arnaldi.json`, pronostico "1 Musetti" @1.36, confidenza 58/100, nessun value bet), partita in programma lunedì 27/07/2026: appena giocata, verificare con la skill e validare l'intero processo (analisi → salvataggio → dashboard → verifica) in un colpo solo, segnalando qualunque cosa non sia andata come previsto. Include ora anche il primo test a mano del flusso reale di `dashboard.html` aggiornata (selettore cartella in lettura/scrittura, campi Importo/Quota editabili, salvataggio su file) — non automatizzabile da browser
- [x] Sessione 2 — dashboard (`Pronostick.Code/dashboard.html`, File System Access API, stesso stile/CSS dell'app originale) — costruita **prima** che la verifica sopra fosse completata (scelta esplicita di Fabio, non l'ordine originariamente previsto: rischio accettato di dover rivedere la dashboard se la verifica rivela un problema di schema). Rendering testato con dati iniettati (stats, filtri, espansione dettaglio); il flusso reale del selettore di cartella nativo non è automatizzabile da browser e resta da testare a mano da Fabio
- [x] Sessione 3 — Guida/FAQ (inizialmente `Pronostick.Code/istruzioni.html`, poi unificata in `dashboard.html` — vedi sotto) — guida completa (scelta esplicita di Fabio tra "essenziale"/"completa"), 5 sezioni (Cos'è, Come si usa, Dati & Memoria, Dashboard, FAQ ad accordion). Tab switching e toggle FAQ verificati via browser. Roadmap Pronostick.Code (Sessioni 1-3) ora completa
- [x] Tracciamento soldi reali — schema (`importo_giocato`/`quota_reale`, sempre `null` dall'analisi) + `dashboard.html` con campi editabili, scrittura su file (File System Access API in lettura/scrittura), KPI (Investito/Vinto/Profitto/ROI Reale) e grafico ROI (Chart.js, con fallback CDN). Chiarito che Pronostick.Code si usa con soldi reali, non solo come laboratorio di ragionamento. Verificato con dati/handle iniettati nel browser (calcoli KPI, editing, salvataggio, gestione errore di scrittura, click sui campi che non richiude la card); il flusso reale del selettore di cartella resta da testare a mano da Fabio
- [x] Unificazione dashboard/guida — `dashboard.html` e `istruzioni.html` uniti in un'unica pagina con toggle 📊 Dashboard/❓ Guida, `istruzioni.html` eliminato (richiesta esplicita di Fabio). Verificato via browser: switch pagina, sotto-tab guida, FAQ, e rendering dashboard invariato dopo il merge

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
- [x] Pronostick.Code — Sessione 1 (fondamenta): struttura cartelle (`Pronostick.Code/`, `pronostici/`, `_inbox/`, entrambe gitignored) + skill `.claude/skills/analizza-locale/SKILL.md` (analisi e verifica via WebSearch nativo, stesso schema JSON del Pronostick reale, isolato e a costo zero) (26/07/2026)
- [x] Pronostick.Code — prima analisi reale con `analizza-locale`: Musetti vs Arnaldi (ATP 500 Washington, 27/07/2026), quota reale trovata (1.36), nessun dato inventato, discrepanze di fonte segnalate in `note_mancanti` invece di forzate. Verifica in sospeso (partita non ancora giocata) (26/07/2026)
- [x] Pronostick.Code — Sessione 2 (dashboard): `dashboard.html`, stesso stile/font/colori di `index.html`, lettura locale via File System Access API, card con stats/filtri/dettaglio espandibile, nessuna scrittura né modifica ai dati. Costruita in anticipo rispetto al completamento della verifica del test (26/07/2026)
- [x] Pronostick.Code — Sessione 3 (guida/FAQ): `istruzioni.html`, guida completa (Cos'è, Come si usa, Dati & Memoria, Dashboard, FAQ ad accordion), stesso stile di `dashboard.html`. Tab switching e toggle FAQ verificati via browser. Roadmap Pronostick.Code (Sessioni 1-3) completa (26/07/2026)

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
| 26/07/2026 | Esplorata un'estensione ibrida di Pronostick (stesso storico/Statistiche/AI Memory condivisi tra due motori, API + Claude Code) e scartata per il rischio di una decisione architetturale difficile da disfare sul prodotto reale. Avviato invece un progetto satellite separato **Pronostick.Code**: stessa qualità di analisi, motore Claude Code (WebSearch nativo) invece di API, dati isolati su file locali, verifica anch'essa via Claude Code (non API) per un ciclo di lezioni con un unico giudice coerente. Travaso di eventuali miglioramenti verso il Pronostick reale sempre manuale, mai automatico | Fabio vuole usare Claude Code per affinare il ragionamento di analisi a costo zero (piano Pro) prima di spendere credito API per testare iterazioni — stesso pattern già validato sul progetto gemello Bracco (motore Claude Code + dati su file locali, nessuna webapp con chiamate a pagamento) |
| 26/07/2026 | Applicata patch a `CLAUDE.md` (Gestione modello): obbligo di chiedere il modello/impegno attuale prima di proporre un'escalation, e valutazione del trigger anche in fase di discussione architetturale, non solo prima del codice | Trovato un caso reale nella sessione: proposta di escalation a modello intermedio quando Fabio aveva già quel livello impostato — stesso gap già risolto nel `CLAUDE.md` del progetto gemello Bracco |
| 26/07/2026 | Costruita la Sessione 2 di Pronostick.Code (dashboard) prima di completare la verifica del primo test end-to-end, invertendo l'ordine scritto nella roadmap dello stesso giorno | Scelta esplicita di Fabio (chiesto con AskUserQuestion vista la task ambigua). Si accetta il rischio che la verifica di lunedì 27/07 riveli un problema di schema/logica da correggere anche nella dashboard già costruita; la validazione dell'intero processo (analisi→salvataggio→dashboard→verifica) resta comunque rimandata a quel momento |
| 26/07/2026 | Applicata patch a `CLAUDE.md` (Definizione di "funzionalità completata"): funzionalità che dipendono da un dialogo nativo del sistema operativo vanno sempre testate a mano da Fabio | Scoperto testando il dashboard di Pronostick.Code: l'automazione browser non può interagire con il selettore di cartella nativo (File System Access API), limite non anticipato da nessuna regola esistente |
| 26/07/2026 | Aggiunto tracciamento soldi reali a Pronostick.Code (`importo_giocato`/`quota_reale`, KPI, grafico ROI in `dashboard.html`), stessi nomi campo e stessa logica di calcolo del Pronostick reale (`renderStats()`/`renderRoiChart()` in `index.html`). I due campi restano sempre `null` nell'output della skill di analisi — li inserisce solo Fabio nella dashboard | Fabio ha chiarito (chiesto con AskUserQuestion) di voler usare Pronostick.Code esattamente come il Pronostick vero, comprese le giocate reali — non solo un laboratorio di ragionamento a costo zero come inquadrato finora |
| 26/07/2026 | Unificate `dashboard.html` e `istruzioni.html` (Sessioni 2 e 3) in un'unica pagina con toggle Dashboard/Guida, eliminato il file `istruzioni.html` separato | Richiesta esplicita di Fabio — un solo file da mantenere invece di due, coerente col principio di semplicità di manutenzione |

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
| 26/07/2026 | Fabio ha chiesto di controllare il progetto gemello Bracco (motore Claude Code invece di API, dati su file locali) e valutare se replicare il pattern in Pronostick. Discussione lunga, senza codice fino alla decisione finale: esplorata prima un'estensione ibrida dentro `index.html` (stesso storico/Statistiche/AI Memory per due motori), scartata per rischio architetturale sul prodotto reale già in uso; scelto invece un progetto satellite separato e reversibile, **Pronostick.Code**. Decisioni chiave: stessa qualità di analisi dell'API, verifica anche quella via Claude Code (non API, per un giudizio coerente), dati/memoria isolati su file locali, nessun confronto automatico tra i due motori nella skill, travaso di miglioramenti verso il Pronostick reale sempre manuale. Costruita la Sessione 1 (fondamenta): `Pronostick.Code/` (`LEGGIMI.md`, `pronostici/`, `_inbox/`, ultime due gitignored) + skill `.claude/skills/analizza-locale/SKILL.md` (schema analisi/verifica allineato a `buildPrompt()`/`verificaRisultato()`/`buildMemory()` di `index.html`). REGISTRA eseguito: Fase 1 PATCH applicata a `CLAUDE.md` (Gestione modello — chiedere sempre il modello/impegno attuale prima di proporre un cambio, trigger valido anche in fase di discussione), trovata perché in questa stessa sessione era scattato l'errore che la patch previene. Non ancora testata dal vivo la skill (prima analisi/verifica reale resta in Task Aperte). Compresse in Archivio Log le 2 voci di sessione del 16/07/2026. **Continuazione stessa giornata:** eseguita la prima analisi reale con `analizza-locale` (Musetti vs Arnaldi, ATP 500 Washington, partita il 27/07 — quota reale 1.36 trovata, nessun value bet identificato, discrepanze di fonte dichiarate in `note_mancanti`). Chiesto a Fabio se procedere con la Sessione 2 (dashboard) prima o dopo la verifica: scelta esplicita di procedere subito, accettando il rischio di dover rivedere la dashboard se la verifica di lunedì rivela un problema di schema. Costruita `Pronostick.Code/dashboard.html` (stesso stile dell'app originale, File System Access API, card con stats/filtri/dettaglio, nessuna scrittura dati) — rendering verificato iniettando dati reali nel browser, il flusso reale del selettore di cartella nativo (non automatizzabile) resta da testare a mano da Fabio. Prossimo passo: a partita giocata, verificare il pronostico e validare l'intero processo in un solo giro, segnalando eventuali problemi. **Continuazione stessa giornata (2):** costruita la Sessione 3 (`Pronostick.Code/istruzioni.html`, guida completa scelta esplicitamente da Fabio su AskUserQuestion) — roadmap Pronostick.Code (Sessioni 1-3) ora chiusa. REGISTRA eseguito: Fase 1 PATCH nessun gap non banale trovato; compressa la sezione ridondante "Bug risolti" in `pronostick_stato.md` per rientrare nel limite di 150 righe indicato in testa al file. Prossimo passo invariato: verificare Musetti-Arnaldi a partita giocata (27/07/2026). **Continuazione stessa giornata (3):** Fabio ha notato che il dashboard di Pronostick.Code non aveva traccia di soldi giocati/ROI come il Pronostick reale. Chiarito con AskUserQuestion che non è solo un laboratorio di ragionamento: si usa esattamente come il Pronostick vero, comprese le giocate con soldi reali. Aggiunto lo schema (`importo_giocato`/`quota_reale`, sempre `null` dall'analisi — li compila solo Fabio nella dashboard) e, in `dashboard.html`, campi editabili con salvataggio su file (File System Access API ora in lettura/scrittura, non più sola lettura), KPI Investito/Vinto/Profitto/ROI Reale e grafico ROI (Chart.js con fallback), stessa logica di `renderStats()`/`renderRoiChart()` del Pronostick reale. Verificato tutto con dati/handle iniettati nel browser (calcoli, editing, salvataggio, errore di scrittura esplicito, click sui campi che non richiude la card); il flusso reale del selettore di cartella resta da testare a mano da Fabio. Aggiornati di conseguenza `SKILL.md` (changelog v1.1) e la guida. Poi, su richiesta di Fabio, unificate `dashboard.html` e `istruzioni.html` in un'unica pagina con toggle 📊 Dashboard/❓ Guida, eliminato `istruzioni.html` — verificato via browser (switch pagina, sotto-tab guida, FAQ, rendering dashboard invariato). REGISTRA eseguito: Fase 1 PATCH nessun gap di processo trovato; corretta in `CLAUDE.md` e nella guida una nota su `_inbox/` rimasta stale da Sessione 1 ("riservata alla futura dashboard", ormai già costruita). |

## Archivio Log
> Sessioni e decisioni più vecchie, spostate qui il 14-26/07/2026 per restare sotto le 150 righe — dettaglio ridotto, il codice/git history restano la fonte primaria per i dettagli tecnici.

### Sessioni precedenti
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

> Bug risolti dalla code review 14/07/2026 (A1-A5, B1-B5, C2) — dettaglio completo nella voce "Sessioni precedenti" sopra e nel commit.

---

## Note Tecniche
- index.html: singolo file ~4900 righe, tutto inline
- Proxy Netlify timeout: 26s max (non aumentabile senza piano Pro)
- Non usare innerHTML per card DOM (preservare event listener)
- Attenzione virgolette singole in stringhe JS con HTML
- Python 3.12 e Node.js LTS installati in locale (14/07/2026) — server di anteprima disponibile con `.claude/launch.json` (`localhost:8080`), utile per testare modifiche prima del push
- Il tool di lettura file di Claude Code può mostrare `<\div>`/`<\span>` invece di `</div>`/`</span>` nel suo output per righe molto lunghe — è un artefatto di visualizzazione, non il contenuto reale del file. Verificare sempre con grep sul file prima di considerarlo un bug (falso allarme scoperto 14/07/2026)
