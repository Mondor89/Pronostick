# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 14/07/2026 |
| **Ultima sessione** | Implementata la logica condizionale per il tool `web_search`: `web_search_20260209` (dynamic filtering) per i modelli che lo supportano, `web_search_20250305` per gli altri |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata. Nessun bug noto aperto al momento. Chiusa la task rimandata dalla sessione precedente: upgrade condizionale del tool `web_search` in base al modello selezionato. Prossimo passo: sistema Tag Pattern per AI Memory.

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
- [ ] Filtro date nello storico

### Priorità Media
- [ ] Aggiornare sezione Guida con le nuove feature

### Priorità Bassa
- [ ] Da definire nelle prossime sessioni

---

## Task Completate
- [x] App web single-page completa con 6 tab
- [x] Integrazione Anthropic API via proxy Netlify
- [x] Firebase Firestore per sync cloud
- [x] Firebase Google Auth
- [x] Dropdown 16 sport + campo "Altro" personalizzato
- [x] Mercati dinamici per sport + pulsante TUTTI i mercati
- [x] Pannello costi (Token AI, Web Search, Cerca Quote)
- [x] Toggle Cerca Quote + dropdown 12 bookmaker + custom
- [x] Quote Bookmaker pannello collassabile
- [x] AI Memory
- [x] Tab Giocata, Calendario, Storico, Guida, Menu funzionanti
- [x] Deploy su Netlify funzionante
- [x] Code review completo di index.html (14/07/2026) — 5 bug reali trovati e corretti (vedi Log Sessioni)
- [x] Cartella locale collegata al repo GitHub Mondor89/Pronostick (14/07/2026) — ora Claude Code può committare e pushare direttamente
- [x] Applicato `CLAUDE_APP_TEMPLATE.md` al progetto (14/07/2026) — creati `CLAUDE.md` e `pronostick_sicurezza.md` (vedi Decisioni Prese)
- [x] Aggiunti comandi PATCH e auto-audit a `CLAUDE.md` (14/07/2026) — sincronizzati anche nei template GAME/ROBLOX/APP
- [x] Verificata struttura file progetto con Claude Code — coerente con `CLAUDE.md`, nessun file orfano (14/07/2026)
- [x] Aggiunto `.gitignore` (14/07/2026)
- [x] Creato `scripts/check-known-bug-patterns.sh` — controllo euristico dei pattern-trappola (precedenza operatori, apici vs backtick, escaping mancante), richiamato nella checklist pre-commit di `CLAUDE.md` (14/07/2026)
- [x] Regole Firestore corrette scritte in `firestore.rules` e pubblicate da Fabio in console (14/07/2026) — chiude invariante #5
- [x] Corretto `logoutGoogle()` (index.html:1996) — non svuotava `localStorage` (storico/calendario) al logout, dati restavano visibili come se l'utente fosse ancora loggato (14/07/2026)
- [x] Installati Python 3.12 e Node.js LTS in locale + `.claude/launch.json` (server statico Python su porta 8080) per testare l'app in anteprima prima del push, invece di aspettare sempre il deploy Netlify (14/07/2026)
- [x] Verificato il fix di `logoutGoogle()` in anteprima locale: dati finti in `localStorage` correttamente svuotati dopo il logout, nessun errore console (14/07/2026)
- [x] Verificato funzionalmente il sync Firestore dopo le nuove regole (14/07/2026) — Fabio ha salvato un pronostico nello storico, rimasto persistito
- [x] Corretto self-XSS in `updateAuthUI()` (index.html:2101-2102) — `photoURL`/`displayName` ora passati da `escapeHtml()` (14/07/2026)
- [x] Aggiunto pulsante elimina singola per le partite passate nel calendario, `renderCalendario()` (index.html:3468-3477) — riusa `rimuoviDalCalendario()` già esistente (14/07/2026)
- [x] Trovato e corretto un terzo bug durante la sessione: `renderCalendario()` non escapava team1/team2/competizione/sport/ora/stadio — corretto e verificato con payload XSS in localStorage (14/07/2026)
- [x] Controllati i model ID Anthropic nel dropdown Menu ⚙️ (`index.html:1680-1683`) — trovati `claude-sonnet-4-20250514` e `claude-opus-4-20250514` già oltre la data di ritiro Anthropic (15/06/2026), a rischio 404 silenzioso. Sostituiti con `claude-sonnet-5` e `claude-opus-4-8`; mantenuti invariati Haiku 4.5 e Sonnet 4.5. Verificato in anteprima locale: dropdown corretto, selezione salva su `localStorage`, nessun errore console (14/07/2026)
- [x] Upgrade condizionale del tool `web_search_20250305` → `web_search_20260209` (dynamic filtering) in base al modello selezionato — aggiunta `getWebSearchTool()` (`index.html:2459-2465`) che usa la variante dynamic filtering per `claude-sonnet-5`/`claude-opus-4-8` e la variante base per `claude-haiku-4-5`/`claude-sonnet-4-5` (non supportata). Sostituiti tutti e 4 i punti che costruivano il tool a mano (`fetchWebData`, ricerca calendario, `verificaRisultato`, `callProxy`) con la nuova funzione condivisa. Verificato in anteprima locale con tutti e 4 i modelli del dropdown, nessun errore console (14/07/2026)

---

## Bug Noti

Nessun bug noto aperto al momento (ultimi 3 chiusi il 14/07/2026 — vedi Log Sessioni).

---

## Decisioni Prese
> Aggiorna ad ogni sessione. Serve a non ripercorrere strade già valutate.

| Data | Decisione | Motivazione |
|------|-----------|-------------|
| 25/04/2026 | Proxy Netlify per API key | Sicurezza — key non esposta nel frontend |
| 25/04/2026 | Firebase Firestore per sync | Gratuito nel piano attuale |
| 25/04/2026 | Haiku come modello AI su Tier 1 | Rate limit più alto di Sonnet su Tier 1 |
| 25/04/2026 | Singolo file HTML inline | Semplicità di deploy su Netlify |
| 14/07/2026 | Adottato `CLAUDE.md` (Claude Code) basato su `CLAUDE_APP_TEMPLATE.md` + nuovo file `pronostick_sicurezza.md` | Standardizzare il workflow con gli altri progetti (giochi) e formalizzare le invarianti di sicurezza emerse dal code review |
| 14/07/2026 | Aggiunti comandi PATCH e auto-audit a `CLAUDE.md`, ispirati alle regole `claude_doc_rules.md` di un altro progetto Claude | Colmare un gap: prima non esisteva un modo esplicito per far emergere/correggere regole del CLAUDE.md stesso durante o a fine sessione |
| 14/07/2026 | Per verificare le regole Firestore (invariante #5), niente Firebase CLI/service account: Fabio copia le regole dalla console e le incolla/salva come `firestore.rules` nel repo | Claude Code non può ricevere password/API key/token per regola fissa di sicurezza; il copia-incolla ottiene lo stesso risultato (verifica + versionamento) senza gestire credenziali |
| 14/07/2026 | Installati sia Python che Node.js in locale (non solo Python) | Fabio ha chiesto esplicitamente entrambi; Node abilita anche npm/Firebase CLI in futuro, Python resta comunque l'opzione minima per il solo server di anteprima statico |
| 14/07/2026 | Il comando REGISTRA ora esegue prima l'analisi PATCH (Fase 1, con discussione ed eventuale conferma delle modifiche a `CLAUDE.md`) e solo dopo il REGISTRA vero e proprio (Fase 2) | Evitare commit frammentati come accaduto in questa sessione (REGISTRA committato, poi PATCH proposta a parte) — un solo commit coerente per sessione |
| 14/07/2026 | Aggiunta alla Checklist pre-commit di `CLAUDE.md` la verifica in anteprima locale prima del push, quando la modifica non richiede login | Ora che Python/Node sono disponibili in locale, senza questa riga si rischiava di continuare ad affidarsi solo al deploy Netlify per accorgersi di un errore |
| 14/07/2026 | PATCH applicata a `CLAUDE.md` (regola Escaping HTML) e a `pronostick_sicurezza.md` (invariante #4): l'elenco delle funzioni da controllare per l'escaping ora include `renderCalendario()` ed è dichiarato esplicitamente non esaustivo | La sessione ha trovato una violazione reale in `renderCalendario()` non coperta dall'elenco precedente — un elenco fisso rischia di restare incompleto ogni volta che si aggiunge una nuova funzione di rendering |
| 14/07/2026 | Sostituiti solo i 2 model ID deprecati nel dropdown (`sonnet-4`→`sonnet-5`, `opus-4`→`opus-4-8`), lasciando invariati Haiku 4.5 e Sonnet 4.5 | Fabio ha scelto l'opzione a minimo impatto tra tre proposte (fix minimo / minimo impatto / rifacimento completo lista+guida) — priorità a chiudere subito il rischio 404, senza aprire una revisione più ampia in questa sessione |
| 14/07/2026 | PATCH applicata a `CLAUDE.md` (Note permanenti): aggiunta regola di riverifica periodica dei model ID Anthropic nel dropdown | 2 modelli su 4 nel dropdown erano già oltre la data di ritiro Anthropic senza che nulla lo segnalasse — un modello deprecato fallisce solo alla chiamata reale, silenziosamente |
| 14/07/2026 | Aggiunta funzione condivisa `getWebSearchTool()` invece di un flag statico o una nuova opzione in `CLAUDE.md`/impostazioni | La scelta della variante `web_search` dipende dal modello già selezionato dall'utente in Menu ⚙️ — nessun nuovo controllo utente necessario, basta derivarla da `getModel()` |

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

| Data | Attività |
|------|----------|
| 25/04/2026 | Implementazione Cerca Quote, dropdown bookmaker, pannello quote collassabile, pulsante TUTTI i mercati |
| 14/07/2026 | Code review di index.html con Claude Code. Trovati e corretti 5 bug: (1) `buildMemory()` — precedenza operatori errata nel ternario, il testo "lezioni apprese" mandato all'AI era troncato; (2) stesso bug con `||` sui campi "Indovinato/Sbagliato"; (3) `fetchWebData()` — tool_result della ricerca web malformato per lo stesso motivo; (4) `verificaRisultato()` — usava apici singoli invece di backtick, `${entry.team1}` veniva inviato all'AI come testo letterale invece che interpolato; (5) `team1`/`team2`/`competition`/`sport`/`matchDate` non passati da `escapeHtml()` in `renderResult()` e `buildFullDetailHTML()` (rischio XSS basso, self-XSS). Segnalate ma non verificabili da qui: regole sicurezza Firestore, cartella locale non collegata al repo git. |
| 14/07/2026 | Creato `CLAUDE_APP_TEMPLATE.md` (in cartella Skill Claude, base per futuri progetti app) e applicato a Pronostick: nuovo `CLAUDE.md` con identità progetto, principi prodotto, comandi RIEPILOGO/REGISTRA/REVISIONA/VERIFICA-SICUREZZA; nuovo `pronostick_sicurezza.md` con le invarianti di sicurezza (incluso l'item ancora aperto sulle regole Firestore). |
| 14/07/2026 | Discusso con Fabio cosa cambiare avendo Claude Code invece della chat normale. Fatto: (1) verificata struttura file progetto (già coerente con `CLAUDE.md`, nessuna riorganizzazione necessaria), (2) aggiunto `.gitignore`, (3) creato `scripts/check-known-bug-patterns.sh` per intercettare in anticipo i pattern-trappola già noti — lo script ha trovato un nuovo bug reale (self-XSS in `updateAuthUI()`, vedi Bug Noti). Non fatto: lettura automatica delle regole Firestore via Firebase CLI — richiede credenziali che Claude Code non può ricevere; deciso un flusso alternativo senza credenziali (vedi Decisioni Prese). |
| 14/07/2026 | Fabio ha incollato le regole Firestore attuali: erano quelle di default "modalità test" di Firebase, scadute il 17/05/2026, senza alcun controllo `request.auth` — invariante #5 era **violata** (dati di tutti gli utenti leggibili/scrivibili da chiunque fino al 17/05, poi sync bloccato in silenzio per tutti). Scritte regole corrette in `firestore.rules` (isolamento per `request.auth.uid == uid` sui percorsi reali `users/{uid}/data/history` e `users/{uid}/data/calendario`, verificati nel codice). Claude Code non può pubblicarle (modificare le regole di accesso Firebase è un'azione vietata per policy) — **azione richiesta a Fabio**: incollarle in Firebase Console → Firestore Database → Rules → Publish. |
| 14/07/2026 | Fabio ha pubblicato le nuove regole Firestore in console. Invariante #5 chiusa lato regole — resta da fare la verifica funzionale (login + sync storico/calendario reale), aggiunta come task priorità alta. |
| 14/07/2026 | Fabio ha testato manualmente il sync dopo le nuove regole: il salvataggio storico funziona. Trovati 2 bug durante il test: (1) `logoutGoogle()` non svuotava `localStorage`, storico/calendario restavano visibili dopo il logout — **corretto** in questa sessione; (2) partite passate nel calendario non hanno pulsante di eliminazione singola, solo etichetta "Passata" — annotato in Bug Noti, da affrontare in sessione dedicata. Fix del bug (1) non testabile in locale (niente Node/Python installati per un server statico) — verifica rimandata a dopo il deploy Netlify. |
| 14/07/2026 | Installati Python 3.12 e Node.js LTS, creato `.claude/launch.json` per l'anteprima locale; fix di `logoutGoogle()` verificato con successo in locale (dati finti in localStorage correttamente svuotati). Eseguito REGISTRA: aggiornati tutti i `.md` con quanto emerso in sessione. Discussa e applicata una nuova regola di processo: REGISTRA ora esegue prima l'analisi PATCH e solo dopo il salvataggio vero e proprio, in un unico commit — applicata anche la PATCH sulla checklist pre-commit (verifica in anteprima locale prima del push). |
| 14/07/2026 | Corretti i 2 bug noti aperti: (1) self-XSS in `updateAuthUI()` — `photoURL`/`displayName` ora passati da `escapeHtml()`; (2) `renderCalendario()` — aggiunto pulsante 🗑 elimina singola anche per le partite passate, riusando `rimuoviDalCalendario()` già esistente. Durante il lavoro sul bug (2) trovato un terzo bug non pianificato: team1/team2/competizione/sport/ora/stadio in `renderCalendario()` non passavano da `escapeHtml()` — corretto su richiesta esplicita di Fabio ("correggi ora") invece di limitarsi ad annotarlo in Bug Noti. Tutti e 3 verificati in anteprima locale: script pattern-trappola eseguito (solo il solito falso positivo sul backtick), test manuale con payload XSS reali (`<img onerror>`, `<script>`) iniettati in localStorage — nessuna esecuzione, nessun errore console. Eseguito REGISTRA: Fase 1 PATCH proposta e confermata da Fabio (elenco funzioni escaping in CLAUDE.md/sicurezza.md dichiarato non esaustivo + aggiunto `renderCalendario()`), poi Fase 2 con aggiornamento di tutti i `.md`. |
| 14/07/2026 | Su richiesta di Fabio, controllati i modelli AI usati da Pronostick contro il catalogo Anthropic corrente. Trovato: dei 4 modelli nel dropdown Menu ⚙️ (`index.html:1680-1683`), `claude-sonnet-4-20250514` e `claude-opus-4-20250514` avevano già superato la data di ritiro Anthropic (15/06/2026) — rischio concreto di errore 404 silenzioso per gli utenti che li selezionavano. Presentate 3 opzioni a Fabio (fix minimo / minimo impatto mantenendo struttura / rifacimento completo); scelta l'opzione a minimo impatto: sostituiti i 2 ID deprecati con `claude-sonnet-5` e `claude-opus-4-8`, lasciati invariati Haiku 4.5 e Sonnet 4.5. Verificato in anteprima locale (dropdown corretto, `saveModel()` salva su `localStorage`, nessun errore console). Controllato anche il resto del codice per altre obsolescenze: nessun controllo hardcoded sul nome modello, header `anthropic-version` corretto, nessuna dipendenza/versione Node obsoleta in `netlify.toml`. Trovato un punto non urgente: il tool `web_search_20250305` (4 occorrenze) è la variante "base", ancora funzionante con tutti i modelli — esiste una variante più recente (`web_search_20260209`, dynamic filtering) ma supportata solo da Sonnet 5/4.6 e Opus 4.6+, non da Haiku 4.5/Sonnet 4.5 tuttora in uso; rimandato a sessione dedicata (vedi Task Aperte) perché richiede logica condizionale per modello, non un semplice swap. Eseguito REGISTRA: Fase 1 PATCH proposta e confermata (aggiunta a `CLAUDE.md` la regola di riverifica periodica dei model ID), poi Fase 2 con aggiornamento di tutti i `.md`. |
| 14/07/2026 | Sessione dedicata all'upgrade condizionale del tool `web_search`, come annotato nella sessione precedente. Aggiunta `getWebSearchTool()` (`index.html:2459-2465`): usa `web_search_20260209` (dynamic filtering) per `claude-sonnet-5`/`claude-opus-4-8`, `web_search_20250305` per `claude-haiku-4-5`/`claude-sonnet-4-5` (non supportano la variante dynamic filtering). Sostituiti i 4 punti che costruivano il tool manualmente. Verificato in console del browser (anteprima locale) che la funzione restituisce il tool corretto per tutti e 4 i modelli del dropdown; nessun errore console. Non eseguiti REVISIONA/VERIFICA-SICUREZZA formali (nessun nuovo input utente, secret o dato persistito — soglia "salta" del `CLAUDE.md`). Eseguito REGISTRA: Fase 1 senza PATCH (nulla di non banale emerso), Fase 2 con aggiornamento dei `.md`. |

## Archivio Log
> Sposta qui le sessioni più vecchie quando il log diventa lungo.

---

## Note Tecniche
- index.html: singolo file ~4800+ righe, tutto inline
- Proxy Netlify timeout: 26s max (non aumentabile senza piano Pro)
- Non usare innerHTML per card DOM (preservare event listener)
- Attenzione virgolette singole in stringhe JS con HTML
- Python 3.12 e Node.js LTS installati in locale (14/07/2026) — server di anteprima disponibile con `.claude/launch.json` (`localhost:8080`), utile per testare modifiche prima del push
