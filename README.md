# ref4ep-webseite

Quellcode der oeffentlichen Projektseite <https://www.ref4ep.de>.

Statisches HTML ohne Generator und ohne Build-Schritt: Was hier liegt,
liegt auch auf dem Server. Das interne Projektportal ist ein eigenes
Projekt (<https://github.com/KHolste/ref4ep-portal>, ausgeliefert unter
`portal.ref4ep.de`).

## Aufbau

```
index.html                     Startseite (Ankernavigation: Projekt, Ziele, Akteure, ...)
impressum.html                 Impressum
datenschutz.html               Datenschutzerklaerung
assets/style.css               gemeinsame Gestaltung aller Seiten
software/index.html            Uebersicht des Bereichs Software
software/iontrace/index.html   Produktseite IONTRACE
software/iontrace/bilder/      Abbildungen, fuer das Web aufbereitet
```

Die Gestaltung lag frueher als `<style>`-Block in `index.html`. Sie
steht jetzt in `assets/style.css`, damit alle Seiten dieselbe Grundlage
nutzen. Der obere Teil der Datei ist unveraendert uebernommen;
Ergaenzungen stehen am Dateiende ab dem Abschnitt `Bereich Software`.

## Bilder

Abbildungen werden vor dem Einchecken verkleinert (Breite 1400-1800 px,
JPEG, Qualitaet 86, progressiv). Rohdaten aus den Simulationslaeufen
sind mehrere Megabyte gross und gehoeren nicht ins Repo.

## Neue Software ergaenzen

1. Ordner `software/<name>/` mit `index.html` anlegen; die IONTRACE-Seite
   ist die Vorlage.
2. Kachel in `software/index.html` ergaenzen.
3. Bilder nach `software/<name>/bilder/` legen, vorher verkleinern.

Download-Dateien (Installationsprogramme) liegen bewusst **nicht** im
Repo — sie werden direkt auf dem Server unter
`software/<name>/download/` abgelegt.

## Ausliefern

Auf dem Server liegt ein Klon unter `/opt/ref4ep-webseite`, den nginx
direkt ausliefert.

```bash
ssh forge
cd /opt/ref4ep-webseite
git pull
```

Kein Neustart noetig — es sind statische Dateien.
