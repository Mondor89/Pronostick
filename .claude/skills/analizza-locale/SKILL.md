---
name: analizza-locale
description: Genera e verifica pronostici sportivi in locale usando le capacità native di Claude Code (WebSearch + ragionamento), senza consumare l'API a pagamento di Pronostick. Fa parte di Pronostick.Code, un laboratorio locale per affinare il ragionamento di analisi a costo zero prima di eventualmente portarlo nel Pronostick reale. Usa quando Fabio chiede di analizzare o verificare una partita "in locale"/"con Claude Code"/dentro Pronostick.Code.
---

# Analizza Locale — Pronostick.Code

> Motore locale di Pronostick.Code — stesso schema di analisi/verifica del Pronostick reale
> (`buildPrompt()`, `verificaRisultato()`, `buildMemory()` in `index.html`), ma eseguito da Claude
> Code con WebSearch nativo invece che tramite l'API Anthropic a pagamento. Nessun collegamento al
> Pronostick reale (niente localStorage, niente Firestore, niente API key) — dati e "memoria"
> vivono solo qui, in `Pronostick.Code/pronostici/`.

## Cosa fa

- Analizza una partita (squadre, sport, competizione, data) e produce un pronostico completo, con
  lo stesso livello di dettaglio dell'app via API (pronostico principale, mercati, value bet, come
  giocarla)
- Verifica un pronostico già salvato, dopo che la partita si è giocata: cerca il risultato reale,
  giudica cosa è stato indovinato/sbagliato, scrive una lezione
- Applica automaticamente le lezioni apprese dai pronostici già verificati per migliorare i
  pronostici successivi (stessa logica di `buildMemory()` in `index.html`)

## Cosa NON fa

- Non tocca in alcun modo il Pronostick reale (`index.html`, localStorage, Firestore) — è un
  laboratorio isolato
- Non confronta automaticamente i propri risultati con quelli del Pronostick reale — un eventuale
  confronto side-by-side resta una scelta manuale e occasionale di Fabio, fuori da questa skill
- Non decide da sola quando "portare" un miglioramento di ragionamento nel Pronostick reale — resta
  sempre un passo manuale deciso da Fabio

## Procedura — Analisi

1. Fabio chiede di analizzare una partita (squadre, sport; competizione/data/contesto se disponibili)
2. Prima di cercare, dichiara: "ANALIZZO: [squadra1] vs [squadra2] ([sport], [competizione o 'non
   specificata']) — cerco forma, notizie, quote se disponibili"
3. Cerca dati reali via WebSearch: forma recente, notizie/infortuni, quote bookmaker se reperibili
   — stessa profondità che l'app chiederebbe con la ricerca dati in tempo reale attiva
4. Legge le lezioni apprese esistenti (vedi sezione "Lezioni apprese" sotto) e le applica al
   ragionamento
5. Prepara l'output secondo lo schema sotto — stesso rigore del prompt reale: valori realistici,
   mai placeholder. `value_bet` va calcolato solo se c'è una quota (reale o stimata) da confrontare
6. Salva in `Pronostick.Code/pronostici/<id>.json` (vedi ID sotto) — mai sovrascrivere un file
   esistente, mai un dato inventato per riempire un campo mancante: usa `note_mancanti` invece di
   fabbricare un valore plausibile
7. Comunica a Fabio: partita analizzata, pronostico principale, percorso del file

## Procedura — Verifica

1. Fabio chiede di verificare un pronostico (per id, o per squadre/data), oppure chiede di
   verificare tutto quello che è pronto (partite con `matchDate` passata e `status:"in_attesa"`)
2. Per ciascuna, dichiara cosa cerchi: "VERIFICO: [squadra1] vs [squadra2] del [data] — cerco il
   risultato finale"
3. Cerca via WebSearch il risultato reale — se non lo trovi, segnalalo e lascia lo status invariato
   (mai inventare un risultato)
4. Se la partita non risulta ancora giocata, dillo esplicitamente e non forzare un giudizio
5. Confronta pronostico salvato vs risultato reale, produci il giudizio secondo lo schema sotto
6. Aggiorna il file: `status` (vinto/perso/pareggio), campo `verifica` popolato
7. Comunica a Fabio l'esito
8. Più verifiche in coda non sono un batch automatico silenzioso: elencale e fatti confermare da
   Fabio quali processare, stesso principio del comando `ELABORA` di Bracco

## ID pronostico

`<matchDate, o data odierna se non nota>_<slug-team1>-vs-<slug-team2>` (es.
`2026-08-02_inter-vs-milan`). Collisione → suffisso `-2`, `-3`…

## Schema di output — analisi (allineato a `buildPrompt()`/`saveCurrentPronostico()` in `index.html`)

```json
{
  "id": "2026-08-02_inter-vs-milan",
  "creato_il": "ISO date",
  "fonte": "locale",
  "sport": "", "team1": "", "team2": "", "competition": "", "matchDate": "YYYY-MM-DD",
  "pronostico_principale": "es. 1 o X o 2 o Over 2.5 o GG",
  "descrizione_pronostico": "",
  "quota_stimata": "numero es. 1.85",
  "confidenza": 0,
  "probabilita_1": 0, "probabilita_x": 0, "probabilita_2": 0,
  "analisi_forma": "", "analisi_tattica": "", "fattori_chiave": "",
  "rischio": "BASSO o MEDIO o ALTO",
  "risultato_esatto_ipotetico": "",
  "consiglio_aggiuntivo": "",
  "value_bet_principale": true,
  "value_bet_score": "numero o null",
  "mercati": {
    "mercato_over_under_2_5": {
      "consiglio": "es. Over 2.5", "probabilita": 0,
      "quota_stimata": "", "quota_bookmaker": null,
      "value_bet": false, "note": ""
    }
  },
  "come_giocarla": {
    "passo1": "", "passo2": "", "passo3": "", "passo4": "",
    "quota_da_cercare": "", "importo_consigliato": "Max 5% del budget",
    "avvertenza": "Nessun pronostico è garantito", "vale_la_pena": true
  },
  "note_mancanti": null,
  "lezioni_applicate": 0,
  "status": "in_attesa",
  "verifica": null
}
```

## Schema di output — verifica (allineato a `verificaRisultato()` in `index.html`)

```json
{
  "timestamp": "ISO date",
  "risultato_trovato": true,
  "punteggio_reale": "es. 3-1",
  "vincitore_reale": "Casa o Ospite o Pareggio o Non trovato",
  "pronostico_corretto": true,
  "esito_scommessa": "VINTO o PERSO o PAREGGIO o NON_VERIFICABILE",
  "accuratezza": "ESATTO o PARZIALE o SBAGLIATO o NON_VERIFICABILE",
  "cosa_ha_indovinato": "",
  "cosa_ha_sbagliato": "",
  "nota_apprendimento": ""
}
```

## Lezioni apprese (equivalente locale di `buildMemory()`)

Prima di ogni nuova analisi:

1. Leggi tutti i file in `pronostici/` con `verifica` non nulla e `verifica.risultato_trovato = true`
2. Dai priorità in ordine: stesso sport + stessa competizione → poi solo stesso sport → poi tutti
3. Prendi al massimo le 8 lezioni con priorità più alta
4. Usale per correggere bias sistematici nel ragionamento della nuova analisi — sono contesto per
   il giudizio, non regole rigide da applicare meccanicamente

## Regole ferree

- Mai un pronostico con dati inventati per riempire un campo mancante — usa `note_mancanti`,
  dichiara esplicitamente se un valore si basa solo su conoscenza generale invece che su dati
  trovati
- Mai sovrascrivere un file `.json` esistente
- Mai un giudizio di verifica se il risultato reale non è stato trovato — resta `NON_VERIFICABILE`
- Mai un batch automatico silenzioso, né in analisi né in verifica multipla

## Evoluzione — `!patch`

Quando qualcosa nell'approccio non funziona (schema da correggere, logica lezioni da aggiustare,
output malformato), Fabio scrive `!patch`. Rivedi la sessione corrente, proponi:

```
⚠️ PATCH SUGGERITA
SEZIONE:  [procedura / schema output / lezioni apprese]
PROBLEMA: [cosa non ha funzionato]
MODIFICA: [testo esatto da aggiungere/sostituire]
```

Attendi conferma, poi aggiorna questo stesso file + una riga nel changelog in fondo.

## Changelog

| Versione | Data | Modifica |
|---|---|---|
| 1.0 | 26/07/2026 | Prima versione — Sessione 1 di Pronostick.Code (fondamenta: struttura cartelle + questa skill, nessuna dashboard ancora) |
