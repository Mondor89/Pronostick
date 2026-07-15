---
name: cerca-calendario
description: Cerca il calendario partite di uno o più sport per un periodo indicato, filtra le competizioni minori secondo whitelist, e salva il risultato in un file JSON locale pronto per l'import in Pronostick (tab Calendario, sezione "Incolla o carica risultato ricerca"). Usa quando Fabio chiede di cercare/aggiornare il calendario partite per Pronostick.
---

# Cerca Calendario — Pronostick

> Erede di `pronostick_calendario_project.md` (Project claude.ai esterno), portata dentro Claude Code
> perché entrambi girano sullo stesso piano Pro di Fabio — nessuna differenza di costo, ma un
> passaggio in meno (niente chat separata) e la possibilità di validare l'output contro il parser
> reale di Pronostick (`importaCalendarioIncollato()` in `index.html`), non contro una copia.

## Cosa fa

Cerca il calendario di uno o più sport per il periodo richiesto, screma le competizioni minori
secondo la whitelist sotto, e scrive **un file JSON locale** pronto per l'import in Pronostick.

## Cosa NON fa

- Non genera pronostici, non valuta quote, non decide value bet — resta compito di Pronostick
- Non modifica direttamente i dati di Pronostick (Firestore/localStorage vivono nel browser,
  non sono raggiungibili da qui) — il file va sempre incollato o caricato a mano nella tab Calendario

## Procedura

1. Dichiara le query prima di lanciarle: "CERCHERÒ: 1. ... — motivo. 2. ... — motivo."
2. Max 3 query per sport/periodo richiesto, salvo richiesta esplicita di ricerca più ampia
3. Non ripetere una ricerca già fatta nella stessa sessione
4. Consolida tutti i risultati in un solo blocco prima di scrivere il file
5. Non completare mai un nome parziale trovato nei risultati (solo cognome, iniziale, ecc.) con un
   nome plausibile ma non confermato dalla fonte — meglio lasciare il dato parziale così com'è che
   inventare un'aggiunta che sembra corretta ma non lo è
6. Verifica sempre la data dell'articolo/fonte prima di assegnare il campo `data` — non fidarti
   della cornice temporale di un riepilogo di ricerca aggregato ("oggi", "questa settimana"): può
   mischiare eventi di giorni diversi sotto la stessa etichetta
7. Scrivi il risultato in `calendario/export.json` (cartella nella root del progetto, in `.gitignore`
   — è output temporaneo, non va committato). Sovrascrivi il file ad ogni ricerca.
8. Comunica a Fabio: percorso del file, quante partite trovate, quali fonti consultate — poi
   digli di aprirlo/incollarlo o caricarlo nella tab Calendario di Pronostick

## Schema di output — allineato a `cercaPartite()` in index.html

```json
{
  "sport": "Calcio Serie A",
  "periodo": "questa settimana",
  "cercato_il": "YYYY-MM-DD",
  "fonti_consultate": ["fonte1", "fonte2"],
  "partite": [
    {
      "team1": "nome squadra/giocatore casa",
      "team2": "nome squadra/giocatore ospite",
      "data": "YYYY-MM-DD",
      "ora": "HH:MM oppure null",
      "competizione": "nome lega o torneo",
      "stadio": "nome stadio oppure null"
    }
  ]
}
```

I nomi dei campi e il formato data (`YYYY-MM-DD`) sono obbligatori — il parser lato Pronostick
(`importaCalendarioIncollato()`) valida ogni riga uno per uno e scarta quelle che non rispettano
il formato, mostrando il motivo. Prima di consegnare il file, ricontrolla tu stesso ogni riga
contro questo schema: hai il parser reale in `index.html` a disposizione, usalo per validare,
non fidarti solo di aver seguito lo schema a memoria.

## Whitelist competizioni "principali" (screening)

Elenco iniziale, **non esaustivo** — si arricchisce nel tempo con `!patch` (vedi sotto):

- **Calcio**: Serie A, Serie B, Premier League, La Liga, Bundesliga, Ligue 1, Champions League,
  Europa League, Conference League, partite delle Nazionali maggiori
- **Tennis**: Slam, Masters 1000, tornei ATP/WTA 250+
- **Basket**: NBA, Eurolega, Serie A italiana (LBA)
- *(altri sport: da definire alla prima ricerca reale, aggiungere qui con `!patch`)*

Cosa si intende per "minore" da scremare di default: campionati giovanili/dilettantistici,
campionati esteri di seconda/terza fascia non richiesti esplicitamente, tornei challenger ATP/WTA.

**La whitelist screma solo il default.** Se Fabio chiede esplicitamente uno sport o una
competizione fuori whitelist, va comunque cercata.

## Verifica qualità — responsabilità manuale, non automatizzabile qui

Di tanto in tanto, controlla a campione che le partite trovate corrispondano alla realtà (fonte
ufficiale) — specialmente dopo un `!patch` alla whitelist, o se lo schema di output sembra
derivare nel tempo.

## Evoluzione — `!patch`

Quando qualcosa nell'approccio non funziona (whitelist sbagliata, schema da correggere,
competizioni mancanti, output malformato), Fabio scrive `!patch`. Rivedi la sessione corrente,
proponi:

```
⚠️ PATCH SUGGERITA
SEZIONE:  [whitelist / schema output / procedura]
PROBLEMA: [cosa non ha funzionato]
MODIFICA: [testo esatto da aggiungere/sostituire]
```

Attendi conferma, poi aggiorna questo stesso file + una riga nel changelog in fondo.

## Changelog

| Versione | Data | Modifica |
|---|---|---|
| 1.0 | 15/07/2026 | Migrazione da Project claude.ai esterno (`pronostick_calendario_project.md`) a skill Claude Code — stesso schema/whitelist/disciplina, output ora su file locale invece che in chat |
| 1.1 | 15/07/2026 | Primo test end-to-end reale (Tennis ATP): trovati e corretti un nome inventato ("Facundo Diaz Acosta" al posto del solo "Gomez" dato dalla fonte) e una data sbagliata (partite del 14/07 lette come "oggi" dal riepilogo aggregato). Aggiunti i punti 5-6 alla Procedura |
