# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 15/07/2026 |
| **Ultima sessione** | Ricerca calendario spostata da Project claude.ai a skill Claude Code locale (`cerca-calendario`) + upload file JSON in tab Calendario (Sonnet 5) — testata end-to-end con ricerca reale, trovati e corretti 2 bug (nome inventato, data sbagliata) |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata, nessun bug noto aperto. Sessione del 15/07/2026 (mattina): analisi (non implementazione) del metodo di generazione pronostici e del sistema di apprendimento da utilizzo (`buildPrompt`/`buildMemory`/verifica). Emersa una roadmap a 4 passi progressivi verso il Tag Pattern per AI Memory (vedi Task Aperte), attualmente bloccata sul primo gradino per mancanza di dati (2 pronostici verificati, servono almeno 5-6 per il primo passo).

Sessione del 15/07/2026 (pomeriggio): spostata la ricerca calendario (query web ampie, poco valore analitico) fuori dal budget API a pagamento di Pronostick, su un Project claude.ai dedicato che usa l'uso incluso nel piano Pro. Implementato il lato Pronostick: import calendario da incolla nella tab Calendario, con validazione esplicita riga per riga.

Sessione del 15/07/2026 (sera): consolidata la ricerca calendario dentro Claude Code (stesso piano Pro di Fabio, nessun costo aggiuntivo) invece del Project claude.ai separato — creata skill `.claude/skills/cerca-calendario/SKILL.md`, output su file locale `calendario/export.json` (gitignored). Aggiunto anche upload file diretto nella tab Calendario (accanto al copia-incolla), stessa validazione già esistente riusata. Primo test end-to-end con ricerca reale (Tennis ATP): trovati e corretti un nome giocatore inventato e una data sbagliata (letta da un riepilogo di ricerca aggregato) — nessuno dei due era intercettabile dalla sola validazione di formato. Patch applicate a `SKILL.md` (2) e `CLAUDE.md` (1, vedi sotto). Proposta di Fabio di un comando `!ricerca` per isolare le ricerche dalla chat di coding — discussa, in sospeso: prima verificare se la skill è già invocabile nativamente con `/cerca-calendario` in una sessione nuova, prima di costruire una convenzione ad hoc.

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
- [ ] Verificare in una sessione Claude Code nuova se la skill `cerca-calendario` compare come comando invocabile (`/cerca-calendario`) — se sì, chiuso; se no, valutare fallback `!ricerca` documentato in `SKILL.md`

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

---

## Bug Noti

Nessun bug noto aperto al momento (chiusi tutti in sessione del 14/07/2026 — vedi Log Sessioni). I bug risolti sono compressi in Archivio Log.

---

## Decisioni Prese
> Aggiorna ad ogni sessione. Serve a non ripercorrere strade già valutate. Le decisioni più vecchie/consolidate sono in Archivio Log.

| Data | Decisione | Motivazione |
|------|-----------|--------------|
| 14/07/2026 | Fabio ha scelto di risolvere tutti e 13 i bug noti in un'unica sessione, nonostante non fossero "correlati allo stesso punto del codice" (limite di complessità sessione) | Chiesto esplicitamente a Fabio con AskUserQuestion prima di iniziare, dato il conflitto con la regola — quasi tutti fix piccoli/localizzati, nessuno tocca dati/secret |
| 14/07/2026 | C3: rimosso il valore precompilato "10" dal campo importo giocata (ora solo placeholder) invece di aggiungere un checkbox "ho giocato davvero" | Fix minimo coerente con la logica già esistente (0 = non conteggiato nel ROI), niente feature nuova per un bugfix |
| 14/07/2026 | C4: creata regola CSS `#apikeyCard.configured` legata all'id reale invece di rinominare la card in `.apikey-card` | `.apikey-card` non era mai usata come classe HTML (solo `settings-card`) ed è stata rimossa come CSS morto nello stesso giro (C7) |
| 15/07/2026 | Prima di costruire il Tag Pattern per AI Memory, si passa per una roadmap a 4 step progressivi (spot-check verifica → verifica per-mercato → statistiche di calibrazione aggregate → Tag Pattern) invece di implementarlo direttamente | Il Tag Pattern era un'idea "in pausa" mai validata nel design; con soli 2 pronostici verificati ora, e senza aver mai controllato l'affidabilità della pipeline di auto-verifica AI, costruire subito la soluzione complessa avrebbe rischiato di amplificare un segnale non validato |
| 15/07/2026 | Ricerca calendario partite spostata su un Project claude.ai esterno (uso incluso nel piano Pro) invece di restare sull'API a pagamento di Pronostick; Giocata resta invariata per ora perché nella sua chiamata 1 ricerca-partite e giudizio-pick sono fusi nella stessa chiamata web_search, non separabili senza ristrutturarla | Calendario è pura ricerca (nessuna logica di analisi mischiata), swap 1:1 a basso rischio. Non è lecito né tecnicamente possibile usare l'abbonamento Pro come backend dell'API — resta un Project claude.ai separato, uso manuale con copia-incolla |
| 15/07/2026 | Il Project esterno usa un meccanismo `!patch` leggero (preso da R13 di un altro progetto Claude) per evolvere le sue istruzioni nel tempo, invece di niente o della piena macchina REGISTRA (stato.md/sicurezza.md/decisioni/log) | Fabio ha corretto la proposta iniziale di Claude Code (nessun meccanismo di evoluzione): le istruzioni del Project cambieranno nel tempo (whitelist leghe, schema output), serve tracciarle, ma la piena governance da app di codice è sproporzionata per un solo file di istruzioni senza dati persistenti |
| 15/07/2026 | L'import calendario da incolla riusa `saveCalendario()`/`renderCalendario()` esistenti invece di scrivere un percorso di parsing/render nuovo, e aggiunge validazione esplicita per campo con errori visibili per riga scartata | Riuso = zero nuova superficie XSS (l'escaping è già coperto lì). La validazione per campo chiude un gap notato da Fabio: il riuso delle funzioni garantiva solo la sicurezza del rendering, non la correttezza del contenuto incollato — vedi patch a CLAUDE.md (sezione Import/parsing dati esterni) |
| 15/07/2026 | Ricerca calendario spostata dal Project claude.ai esterno a una skill Claude Code locale (`.claude/skills/cerca-calendario/`), invece di mantenere i due canali paralleli | Fabio usa Claude Code sul piano Pro (stesso di claude.ai) — nessuna differenza di costo, ma un passaggio in meno e la possibilità per Claude Code di validare l'output contro il parser reale (`importaCalendarioIncollato()`) invece che contro una copia di documentazione. `pronostick_calendario_project.md` resta come alternativa, non eliminato |
| 15/07/2026 | Upload file JSON aggiunto in tab Calendario riusando al 100% la validazione esistente di `importaCalendarioIncollato()` (il file letto viene messo nella stessa textarea e la stessa funzione viene richiamata), invece di scrivere un percorso di parsing separato | Zero superficie nuova di validazione/escaping da mantenere — unica differenza è la sorgente del testo (file vs incolla manuale) |
| 15/07/2026 | Proposta di Fabio di un comando `!ricerca` per isolare le ricerche calendario dalla chat di coding — non implementato subito, prima da verificare se `/cerca-calendario` è già invocabile nativamente in una sessione Claude Code nuova | Un marcatore testuale dentro la stessa sessione non risolve il mescolamento di contesto (il problema reale); la separazione va ottenuta con una sessione dedicata, non con una parola chiave. Se la skill non risultasse invocabile nativamente, `!ricerca` documentato in `SKILL.md` resta un fallback ragionevole |

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
| 14/07/2026 | Chiusura di tutti i 13 bug noti rimasti dalla code review precedente (C1, C3-C7, D1-D6). Sessione esplicitamente autorizzata da Fabio a coprire tutti i bug insieme nonostante il limite di complessità. Fix principali: grafico ROI allineato ai KPI (quota_reale), rimosso precompilato 10€ dal calcolatore giocata, ripristinato feedback visivo "API key configurata", rimossi 4 rami di codice morto per web_search (mai eseguiti perché è un tool server-side), rimossi console.log residui, rimossa funzione `handleCardClick()` mai chiamata e CSS morto/duplicato (`.apikey-card`, `.hcard-top` e famiglia, `.btn-ricalcolo`, doppia `.hcard`, media query duplicate), aggiunto favicon, safe-area-inset-bottom sulla tab bar, `rel="noopener"` sui link esterni, fallback per Chart.js irraggiungibile, aria-label sui bottoni-icona, Backup esteso al calendario partite (con retrocompatibilità sui backup vecchi). Verificato dal vivo in anteprima locale via JS console (localStorage seeding, chiamate dirette alle funzioni, nessun errore console) per ogni fix. Falso allarme durante la sessione: un presunto bug di tag HTML rotti (`<\div>`/`<\span>`) visto nell'output del tool di lettura file si è rivelato un artefatto di visualizzazione — verificato con grep sul file reale, il codice è sempre stato corretto. Script pattern-trappola eseguito (solo il solito falso positivo backtick). REGISTRA eseguito: Fase 1 PATCH — nessun gap non banale emerso, nessuna modifica a CLAUDE.md. |
| 15/07/2026 | Analisi (nessun codice toccato) del metodo AI di generazione pronostici e del sistema di apprendimento da utilizzo. Letti `buildPrompt()`, `buildMemory()`, `renderStats()`, `renderBiasPanel()` e la pipeline di verifica (`evalPrompt`). Trovato: le statistiche aggregate (win rate, ROI, confidenza media vs reale) esistono già in `renderStats()` ma non tornano mai nel prompt — `buildMemory()` inietta solo max 8 lezioni testuali scelte per sport/competizione; la verifica giudica solo il pronostico principale, non i singoli mercati, quindi oggi non è possibile calcolare bias per mercato; la pipeline di auto-verifica (AI che cerca il risultato e si autogiudica) non è mai stata validata contro un riscontro umano. Chiarito con Fabio che Claude Code (Sonnet 5) è lo strumento corretto per questa analisi, non serve un modello diverso (Fable 5) — è un lavoro di prompt engineering/architettura dati. Definita una roadmap a 4 step gated da soglie di pronostici verificati (oggi: 2) invece di costruire subito il Tag Pattern. REGISTRA eseguito: Fase 1 PATCH — 1 gap trovato e applicato (vedi Decisioni Prese e CLAUDE.md). |
| 15/07/2026 | Discussa e scartata l'idea di usare l'abbonamento Claude Pro al posto dell'API a pagamento (non lecito/possibile, ToS separati). Proposta alternativa: Project claude.ai esterno per la ricerca calendario, dentro l'uso incluso del Pro. Analizzati 3 file template di un altro progetto Claude (`claude_doc_rules_v1_11.md` + istruzioni + guida HTML) — scartati quasi interamente perché pensati per documenti formattati, non per ricerca dati; riusata solo la disciplina query (R2/R10) e il meccanismo `!patch` (R13). Letto anche `CLAUDE_APP_TEMPLATE.md` per lo stile "perché/cosa". Creato `pronostick_calendario_project.md` con schema output allineato a `cercaPartite()`, whitelist competizioni iniziale, `!patch` per l'evoluzione. Implementato lato Pronostick: import calendario da incolla (tab Calendario) con validazione esplicita per campo, dedup sulla stessa chiave di `cercaPartite()`, riuso di `saveCalendario()`/`renderCalendario()`. Testato in locale: JSON malformato, righe scartate con motivo, duplicati, payload XSS in `team1` correttamente escapato a schermo (0 esecuzioni verificate via DOM). Modello verificato prima di iniziare: Sonnet 5 sufficiente (feature contenuta in una tab). REGISTRA eseguito: Fase 1 PATCH — 1 gap trovato e applicato (vedi CLAUDE.md, sezione Import/parsing dati esterni). |
| 15/07/2026 | Fabio ha proposto di consolidare la ricerca calendario dentro Claude Code invece che su un Project claude.ai separato, dato che entrambi girano sul suo piano Pro (nessuna differenza di costo) — discusso e confermato. Creata skill `.claude/skills/cerca-calendario/SKILL.md` (erede di `pronostick_calendario_project.md`), output su file locale `calendario/export.json` (gitignored). Aggiunto upload file diretto in tab Calendario, riusando al 100% la validazione esistente di `importaCalendarioIncollato()`. Verificato in anteprima locale: upload con dati di test (1 riga valida + 1 scartata per campo mancante) e poi un vero test end-to-end con ricerca web reale (Tennis ATP, 15/07) — durante la stesura del JSON trovati e corretti due errori reali: un nome giocatore inventato per completare un cognome parziale, e una data sbagliata presa da un riepilogo di ricerca che mischiava eventi di giorni diversi sotto "oggi". Nessuno dei due era intercettabile dalla sola validazione di formato già in `importaCalendarioIncollato()`. Applicate 2 patch a `SKILL.md` (non completare nomi parziali, verificare sempre la data della fonte) e 1 patch a `CLAUDE.md` (validazione di formato non basta per dati da ricerca AI). Proposta di Fabio di un comando `!ricerca` per isolare le ricerche dalla chat di coding — discussa, lasciata in sospeso: da verificare prima se `/cerca-calendario` è già invocabile nativamente in una sessione Claude Code nuova (task aperta). REGISTRA eseguito: Fase 1 PATCH — 1 gap trovato e applicato. |

## Archivio Log
> Sessioni e decisioni più vecchie, spostate qui il 14/07/2026 per restare sotto le 150 righe — dettaglio ridotto, il codice/git history restano la fonte primaria per i dettagli tecnici.

### Sessioni precedenti
- **25/04/2026** — Sviluppo iniziale: Cerca Quote, dropdown bookmaker, pannello quote collassabile, pulsante TUTTI i mercati.
- **14/07/2026** — Code review iniziale (5 bug corretti: precedenza operatori, apici vs backtick, escaping mancante) → adottato `CLAUDE.md`/`pronostick_sicurezza.md`, setup Claude Code (`.gitignore`, script pattern-trappola).
- **14/07/2026** — Sicurezza Firestore: regole di default violate trovate e corrette (invariante #5), sync verificato funzionalmente; corretti `logoutGoogle()` ed escaping mancante in `renderCalendario()`.
- **14/07/2026** — Python/Node installati in locale + anteprima locale; sostituiti 2 model ID Anthropic deprecati nel dropdown; aggiunta `getWebSearchTool()` per upgrade condizionale web_search in base al modello.
- **14/07/2026** — Chiuse le task Filtro Data nello Storico e aggiornamento Guida (nuova tab Altre Funzioni, FAQ modello corretta).
- **14/07/2026** — Code review completa (Sonnet 5, impegno alto): 18 problemi trovati (5 critici, 5 sicurezza, 7 minori, 6 UI/UX). Risolti e verificati i 10 critici/sicurezza: A1 (bottoni Ricalcola/Elimina rotti + bug dormiente in `deleteEntry()`), A2 (dettaglio pronostico mai visibile), C2 (pannello Verifica che si richiudeva), B1-B5 (escaping mancante in 7 funzioni — chiude invariante #4), A3 (Enter rotto), A4 (`renderChips()` riscritta con DOM), A5 (svuota calendario sincronizzato con Firebase). PATCH applicata: test end-to-end di handler ripristinati + tecnica payload XSS per fix di escaping.

### Decisioni precedenti
- **25/04/2026** — Proxy Netlify per API key, Firebase Firestore per sync, Haiku come modello su Tier 1, singolo file HTML inline (vedi Principi Prodotto in `CLAUDE.md`).
- **14/07/2026** — Adottato workflow `CLAUDE.md`/PATCH/REGISTRA; regole Firestore verificate via copia-incolla manuale (niente credenziali a Claude Code); Python+Node installati per anteprima locale prima del push.
- **14/07/2026** — PATCH applicate: escaping invariante #4 dichiarato non esaustivo (+ `renderCalendario()`); riverifica periodica model ID; chiarire scopo di task ambigue prima di iniziare una sessione.
- **14/07/2026** — `renderChips()` riscritta con DOM invece di stringhe concatenate (corregge onclick troncato e nome file non escapato in un colpo); priorità mercato vincolata a whitelist invece di solo escapata (finiva in un attributo `class` senza apici).

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
