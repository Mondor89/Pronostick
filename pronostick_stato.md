# Pronostick — Stato del Progetto
> Aggiorna questo file ogni sessione e ricaricalo nel progetto Claude sostituendo il precedente.
> Se supera le 150 righe, segnalalo e chiedi a Fabio come snellirlo prima di aggiornare.

---

## Stato Attuale

| Campo | Valore |
|-------|--------|
| **Ultimo aggiornamento** | 14/07/2026 |
| **Ultima sessione** | Code review completo + fix 5 bug (Claude Code) |
| **Deploy** | https://pronostick.netlify.app/ |
| **GitHub** | Mondo89/Pronostick |
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
- [ ] Sistema Tag Pattern per AI Memory (con 30+ pronostici verificati)
- [ ] Upgrade modello a Sonnet quando Tier 2 (≥$40 spesi)
- [ ] Filtro date nello storico
- [ ] Verificare regole di sicurezza Firestore (users/{uid}/... deve richiedere request.auth.uid == uid) — non verificabile da codice, va controllato in console Firebase

### Priorità Media
- [ ] Aggiornare sezione Guida con le nuove feature
- [ ] Collegare la cartella locale del progetto al repo GitHub (attualmente non è un git repo locale, quindi le modifiche fatte in locale non sono tracciate/pushate automaticamente)

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

---

## Bug Noti

| # | Descrizione | Stato |
|---|-------------|-------|
| — | Nessun bug aperto documentato | — |

---

## Decisioni Prese
> Aggiorna ad ogni sessione. Serve a non ripercorrere strade già valutate.

| Data | Decisione | Motivazione |
|------|-----------|-------------|
| 25/04/2026 | Proxy Netlify per API key | Sicurezza — key non esposta nel frontend |
| 25/04/2026 | Firebase Firestore per sync | Gratuito nel piano attuale |
| 25/04/2026 | Haiku come modello AI su Tier 1 | Rate limit più alto di Sonnet su Tier 1 |
| 25/04/2026 | Singolo file HTML inline | Semplicità di deploy su Netlify |

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

## Archivio Log
> Sposta qui le sessioni più vecchie quando il log diventa lungo.

---

## Note Tecniche
- index.html: singolo file ~4800+ righe, tutto inline
- Proxy Netlify timeout: 26s max (non aumentabile senza piano Pro)
- Non usare innerHTML per card DOM (preservare event listener)
- Attenzione virgolette singole in stringhe JS con HTML
