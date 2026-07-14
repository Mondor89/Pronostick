# Regole di Sicurezza — Pronostick
*Documento operativo. Ogni nuova funzionalità che tocca dati/secret va verificata qui PRIMA dell'implementazione.*

## Invarianti di Sicurezza — Non violare mai

| # | Invariante | Perché è sacra |
|---|-----------|----------------|
| 1 | Nessun secret Anthropic hardcoded nel codice frontend | Il codice client (`index.html`) è sempre leggibile da chiunque |
| 2 | L'API key Anthropic è pattern BYOK: l'utente la inserisce, salvata solo in `localStorage`, mai inviata altrove che al proprio proxy | Evita costi/abusi sull'account di terzi |
| 3 | `netlify/functions/proxy.js` inoltra la richiesta ad Anthropic senza mai loggare o persistere la key ricevuta | Il proxy è l'unico punto server-side — se logga la key, diventa un punto di furto |
| 4 | Ogni input utente (team1, team2, competition, sport, matchDate, ecc.) **e ogni testo generato dall'AI** che finisce in `innerHTML` passa da `escapeHtml()` | Previene XSS, anche self-XSS e XSS indiretto (contenuto ostile in una pagina trovata dal web search che finisce nel testo prodotto dall'AI). Coperte: `renderResult()`, `buildFullDetailHTML()`, `buildCompactCardDOM()`, `renderCalendario()`, `renderStats()`, `renderCombinataResult()`, `buildMercatiConsigliati()`, `renderGiocataResult()`, `renderBiasPanel()`. Elenco indicativo non esaustivo — ogni nuova funzione che scrive `innerHTML` con dati esterni o output AI va verificata |
| 5 | I dati Firestore (`users/{uid}/data/history`, `users/{uid}/data/calendario`) devono essere isolati per utente lato regole di sicurezza | Evita che un utente autenticato legga/scriva i dati di un altro |
| 6 | La `apiKey` Firebase visibile nel client (`firebaseConfig`) NON è un secret — è un identificatore pubblico del progetto, protetto dalle Firestore Rules, non dalla segretezza | Evita falsi allarmi in audit futuri: non va trattata come l'API key Anthropic |

## Stato di verifica

| # | Invariante | Stato | Note |
|---|-----------|-------|------|
| 1-3 | Vedi sopra | ✅ Verificate (code review 14/07/2026) | — |
| 4 | Escaping input utente + output AI prima di `innerHTML` | ✅ **Verificata e corretta (14/07/2026)** | Bug originali (team1/team2/competition/sport/matchDate) corretti il 14/07/2026. Corrette in sessione precedente: `updateAuthUI()` (index.html:2101-2102, `photoURL`/`displayName`) e `renderCalendario()` (index.html:3468-3469, team1/team2/competizione/sport/ora/stadio). Corrette in questa sessione (review completa + fix): `renderStats()`, `renderCombinataResult()`, `renderResult()`, `buildFullDetailHTML()`, `buildMercatiConsigliati()` (priorità vincolata a whitelist, non solo escapata, perché finiva in un attributo `class` senza apici), `renderGiocataResult()`, `renderBiasPanel()` — verificate iniettando lo stesso payload XSS in ogni campo di tutte queste funzioni, 0 esecuzioni. Elenco funzioni non esaustivo — vedi nota nell'invariante sopra |
| 5 | Isolamento dati Firestore per utente | ✅ **Corrette, pubblicate e verificate funzionalmente (14/07/2026)** | Erano le regole di default "modalità test" di Firebase, scadute il 17/05/2026, senza `request.auth` (violazione storica, vedi Registro Decisioni). Fabio ha pubblicato le regole di `firestore.rules` in Firebase Console e testato il salvataggio storico, funzionante. |
| 6 | — | ✅ Nota informativa, nessuna azione richiesta | — |

## Superficie di Attacco per Funzionalità

| Funzionalità | Tocca secret? | Tocca dati utente? | Input esterno non fidato? | Note |
|---|---|---|---|---|
| Analisi pronostico (`analyzeMatch`) | Sì (API key via header) | No | Sì (risposta AI, eventuale web search) | Team/competition/context inseriti dall'utente, ora sanificati |
| Cerca Quote Bookmaker | Sì (API key) | No | Sì (risultato ricerca web) | — |
| Login Google / sync Firebase | No | Sì (storico, calendario) | Parzialmente (`user.displayName` è impostabile dall'utente sul proprio account Google) | Isolamento lato regole vedi #5. `updateAuthUI()` non sanifica `displayName`/`photoURL` — vedi invariante #4, Bug Noti #1 |
| Import/Export backup JSON | No | Sì (dati locali) | Sì (file caricato dall'utente) | `processImport()` — verificare che il parsing non esegua codice, solo `JSON.parse` |

## Checklist VERIFICA-SICUREZZA

- [ ] Viola un'invariante di sicurezza della tabella sopra?
- [ ] Nuovo secret/API key — gestito come Anthropic (BYOK + proxy senza log)?
- [ ] Nuovo punto di input utente — passato da `escapeHtml()` prima di finire nel DOM?
- [ ] Nuovo dato persistito su Firestore — isolato per utente (`users/{uid}/...`)?
- [ ] Nuova chiamata a API esterna — gestita se fallisce/va in timeout?

## Registro Decisioni di Sicurezza

| Data | Decisione | Motivazione |
|------|-----------|--------------|
| 14/07/2026 | File creato, invarianti 1-6 documentate a partire dal code review dello stesso giorno | Formalizzare quanto emerso dalla review di `index.html` |
| 14/07/2026 | Escaping mancante corretto in `renderResult()` e `buildFullDetailHTML()` per team1/team2/competition/sport/matchDate | Rischio XSS (self-XSS) — vedi `pronostick_stato.md` log sessioni |
| 14/07/2026 | Trovate regole Firestore di default (test mode, scadute il 17/05/2026, nessun `request.auth`) — invariante #5 era violata, non solo "da verificare". Scritte regole corrette in `firestore.rules`, in attesa che Fabio le pubblichi in console | Fabio ha incollato le regole attuali su richiesta di Claude Code per chiudere la verifica dell'invariante #5 |
| 14/07/2026 | Corretto self-XSS in `updateAuthUI()` (photoURL/displayName) e trovato+corretto nella stessa sessione un secondo punto non coperto dall'elenco: `renderCalendario()` (team1/team2/competizione/sport/ora/stadio). Elenco funzioni dell'invariante #4 dichiarato non esaustivo | L'elenco fisso di nomi-funzione in CLAUDE.md/sicurezza.md aveva lasciato fuori una funzione di rendering reale — PATCH applicata per prevenire la stessa lacuna in futuro |
| 14/07/2026 | Code review completa (Sonnet 5, impegno alto) ha trovato altre 5 funzioni non coperte dall'invariante #4 — non solo input utente ma anche testo generato dall'AI (analisi, mercati, come_giocarla, motivazioni). Tutte corrette nella stessa sessione: `renderStats()`, `renderCombinataResult()`, `renderResult()`, `buildFullDetailHTML()`, `buildMercatiConsigliati()`, `renderGiocataResult()`, `renderBiasPanel()` | L'invariante #4 copriva esplicitamente solo "input utente", ma l'output AI è influenzabile indirettamente da contenuto ostile trovato dal web search — lo stesso rischio pratico dell'input utente diretto. Estesa la formulazione dell'invariante per includerlo esplicitamente |
