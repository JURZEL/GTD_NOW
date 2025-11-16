# gtd_student

A small open-source Getting Things Done (GTD) helper app for students, built with Flutter.

## About

This project is open-source. If you find it useful, you can support development:

- GitHub: https://github.com/JURZEL/GTD_NOW
- Buy Me a Coffee: https://www.buymeacoffee.com/jurzel

## License

This project is released under the MIT License — see the `LICENSE` file.



## Kurzes Tutorial — Workflow der App

Dieses kleine Tutorial erklärt den typischen Workflow, wie die App beim Organisieren von Aufgaben im GTD‑Stil (Getting Things Done) helfen soll.

### 1) Schnell erfassen (Quick capture)

- Nutze die FAB (Floating Action Button) oder die Schnellerfassung, um Gedanken und Aufgaben sofort festzuhalten.
- Alles geht zunächst in die Inbox — so bleibt dein Kopf frei.

### 2) Inbox verarbeiten

- Öffne die Inbox und entscheide für jeden Eintrag: Löschen, Sofort erledigen, Verschieben in ein Projekt, in die Warteliste oder als Aufgabe mit Fälligkeitsdatum anlegen.
- Füge bei Bedarf Beschreibung, Kontext und Energie-/Zeitangaben hinzu.

### 3) Projekte anlegen und pflegen

- Sammle zusammengehörige Aufgaben in Projekten. Ein Projekt ist jedes Ergebnis, das mehrere Schritte braucht.
- Erstelle ein Projekt, weise Aufgaben zu und verwalte Projekt‑Metadaten (Name, Beschreibung).

### 4) Aktionen (Next Actions)

- Die Ansicht "Actions" zeigt unmittelbar anstehende Aufgaben (Next Actions) nach Kontext, Energielevel oder Zeitfenster gefiltert.
- Markiere Aufgaben als erledigt, verschiebe oder terminiere sie.

### 5) Fälligkeiten & Benachrichtigungen

- Aktiviere Benachrichtigungen in den Einstellungen, damit du zu Fälligkeiten erinnert wirst.
- Die App nutzt zeitbasierte Benachrichtigungen und (bei Bedarf) Fallback‑Erinnerungen auf Plattformen ohne native Unterstützung.

### 6) Wöchentliche Review

- Verwende die "Review"-Funktion, um regelmäßig alle Projekte und Aufgaben zu überblicken und die nächsten Prioritäten zu setzen.

### Tipps

- Verwende die Schnellerfassung, sobald dir etwas in den Sinn kommt. Verarbeite die Inbox in kurzen, regelmäßigen Sessions.
- Nutze Filter (Kontext, Energielevel, Zeitfenster), um passende Aufgaben auszuwählen.
- In den Einstellungen kannst du die App‑Sprache, Benachrichtigungen und Export/Import konfigurieren.

Wenn du möchtest, kann ich dieses Tutorial noch als separate `TUTORIAL.md` auslagern, mit Screenshots ergänzen oder eine kurze Onboarding‑Seite in der App implementieren.


## Image optimizations (docs)

The project's documentation now includes real app screenshots. To keep the docs fast and the repository small we:

- Store the full-size screenshots as modern WebP files under `docs/screenshots/*.webp`.
- Provide small WebP thumbnails under `docs/screenshots/thumbs_small/` (200px wide) that link to the full-size images.

If you need the original PNG exports they were used to generate the WebP files but are not kept in the repository to save space. You can regenerate or re-capture screenshots using an Android emulator and `adb exec-out screencap -p` if needed.

