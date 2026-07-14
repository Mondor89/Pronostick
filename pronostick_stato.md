# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 14/07/2026 |
| **Ultima sessione** | Applicato template CLAUDE.md (Claude Code) |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondor89/Pronostick |
| **Tier Anthropic** | Tier 1 (modello consigliato: Haiku) |

---

## Focus Attuale
App funzionante e deployata, appena passata da un code review approfondito con bug reali corretti (vedi Task Completate). Prossimo passo: sistema Tag Pattern per AI Memory.

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
- [ ] Verificare funzionalmente il sync dopo la pubblicazione delle nuove regole Firestore (14/07/2026) — login Google + salvataggio/lettura storico e calendario, controllare assenza errori in console
- [ ] Sistema Tag Pattern per AI Memory (con 30+ pronostici verificati)
- [ ] Upgrade modello a Sonnet quando Tier 2 (≥$40 spesi)
- [ ] Filtro date nello storico
- [ ] Correggere self-XSS in `updateAuthUI()` (vedi Bug Noti #1)

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

---

## Bug Noti

| # | Descrizione | Stato |
|---|-------------|-------|
| 1 | `updateAuthUI()` (index.html:2097-2098) — `user.photoURL`/`user.displayName` (nome account Google) inseriti in `innerHTML` senza `escapeHtml()`. Rischio self-XSS basso, stessa categoria dei bug corretti il 14/07 su team1/team2 — trovato dal nuovo script `scripts/check-known-bug-patterns.sh` | Aperto — non corretto in questa sessione (fuori scope, da riprendere in una sessione dedicata) |
| 2 | `renderCalendario()` (index.html:3467) — le partite passate mostrano solo l'etichetta "Passata", senza pulsante di eliminazione singola. L'unico modo per rimuoverle è "Svuota tutto il calendario", che cancella anche le partite future | Aperto — trovato durante il test del sync Firestore del 14/07/2026, da affrontare in una sessione dedicata |

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

## Archivio Log
> Sposta qui le sessioni più vecchie quando il log diventa lungo.

---

## Note Tecniche
- index.html: singolo file ~4800+ righe, tutto inline
- Proxy Netlify timeout: 26s max (non aumentabile senza piano Pro)
- Non usare innerHTML per card DOM (preservare event listener)
- Attenzione virgolette singole in stringhe JS con HTML
