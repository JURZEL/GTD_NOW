// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'GTD Student';

  @override
  String get quickCapture => 'Schnelleingabe';

  @override
  String get navInbox => 'Inbox';

  @override
  String get navProjects => 'Projekte';

  @override
  String get navActions => 'Aktionen';

  @override
  String get navReview => 'Review';

  @override
  String get settingsTitle => 'Benachrichtigungen';

  @override
  String get appearanceLabel => 'Darstellung';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get reschedule => 'Neu terminieren';

  @override
  String get markDone => 'Als erledigt markieren';

  @override
  String get markUndone => 'Als unerledigt markieren';

  @override
  String get snooze => 'Schlummern';

  @override
  String get moveToProject => 'Verschieben zu Projekt';

  @override
  String get showDetails => 'Details anzeigen';

  @override
  String get notificationsEnable => 'Benachrichtigungen aktivieren';

  @override
  String permissionsStatus(Object status) {
    return 'Berechtigungen: $status';
  }

  @override
  String get requestPermissions => 'Berechtigung anfragen';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get fallbackReminders => 'Fallback-Erinnerungen (nur Windows/Fuchsia):';

  @override
  String get noFallbacks => 'Keine Fallback-Erinnerungen vorhanden';

  @override
  String get clearAll => 'Alle löschen';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String appLanguageSet(Object locale) {
    return 'App-Sprache gesetzt: $locale';
  }

  @override
  String initializationFailed(Object error) {
    return 'Initialisierung fehlgeschlagen: $error';
  }

  @override
  String get searchTasks => 'Aufgaben';

  @override
  String get searchNoResults => 'Keine Treffer';

  @override
  String deadlineLabel(Object date) {
    return 'Deadline $date';
  }

  @override
  String dueLabel(Object date) {
    return 'Fällig $date';
  }

  @override
  String get createProject => 'Projekt anlegen';

  @override
  String get noProjectsYet => 'Noch keine Projekte. Lege gleich die ersten an!';

  @override
  String errorWith(Object error) {
    return 'Fehler: $error';
  }

  @override
  String openTasksCount(Object count) {
    return 'Offene Tasks ($count)';
  }

  @override
  String get noOpenTasks => 'Keine offenen Aufgaben – stark!';

  @override
  String get dialogCreateProjectTitle => 'Projekt anlegen';

  @override
  String get nameLabel => 'Name';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get delete => 'Löschen';

  @override
  String get confirmDeleteTitle => 'Löschen bestätigen';

  @override
  String confirmDeleteProject(Object name) {
    return 'Projekt \"$name\" löschen?';
  }

  @override
  String projectDeleted(Object name) {
    return 'Projekt \"$name\" gelöscht';
  }

  @override
  String get chooseDate => 'Datum wählen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get saving => 'Speichert...';

  @override
  String get save => 'Speichern';

  @override
  String get weeklyReviewTitle => 'Wöchentliche Review';

  @override
  String get weeklyReviewDescription => 'Räume deinen Kopf auf, sieh alle Projekte durch und plane die nächste Woche.';

  @override
  String get startReview => 'Review starten';

  @override
  String inboxHeader(Object count) {
    return 'Inbox ($count)';
  }

  @override
  String get inboxSubtitle => 'Leere die Inbox regelmäßig, damit nichts verloren geht.';

  @override
  String get emptyInbox => 'Inbox leeren';

  @override
  String maybeLaterHeader(Object count) {
    return 'Vielleicht/Später ($count)';
  }

  @override
  String get reviewLog => 'Review Log';

  @override
  String get reviewNotesTitle => 'Review Notizen';

  @override
  String get backupLabel => 'Backup';

  @override
  String capturedAtLabel(Object date) {
    return 'Erfasst: $date';
  }

  @override
  String get taskLabel => 'Aufgabe';

  @override
  String get somedayLabel => 'Vielleicht/Später';

  @override
  String get twoMinuteRuleTitle => '2-Minuten-Regel: sofort erledigen';

  @override
  String get twoMinuteRuleSubtitle => 'Wenn es schneller geht, hake es direkt ab.';

  @override
  String get notifyOnDueTitle => 'Benachrichtigung bei Fälligkeit';

  @override
  String get notificationChannelDueName => 'Fälligkeiten';

  @override
  String get notificationChannelDueDescription => 'Benachrichtigungen für anstehende Aufgaben';

  @override
  String notificationDueTitle(Object title) {
    return 'Fällig: $title';
  }

  @override
  String get notificationDueBody => 'Bleib dran – du hast es gleich geschafft!';

  @override
  String get linuxNotificationActionOpen => 'Öffnen';

  @override
  String get actionsStatusTitle => 'Status';

  @override
  String get useFabToCapture => 'Nutze den FAB, um neue Gedanken einzufangen.';

  @override
  String get nextActionsTitle => 'Nächste Schritte';

  @override
  String get noActionsMessage => 'Keine Aufgaben für die aktuelle Auswahl. Passe die Filter an.';

  @override
  String get calendarTitle => 'Kalender';

  @override
  String get filterByContext => 'Filter nach Kontext';

  @override
  String get energyLevel => 'Energielevel';

  @override
  String get timeWindow => 'Zeitfenster';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes Min';
  }

  @override
  String hoursLabel(Object hours) {
    return '$hours h';
  }

  @override
  String get permissionGranted => 'Erteilt';

  @override
  String get permissionDenied => 'Nicht erteilt';

  @override
  String get processTitle => 'Verarbeiten';

  @override
  String get titleLabel => 'Titel';

  @override
  String get descriptionOptional => 'Beschreibung (optional)';

  @override
  String get contextLabel => 'Kontext';

  @override
  String get noProject => 'Kein Projekt';

  @override
  String get projectsLoadError => 'Projekte konnten nicht geladen werden';

  @override
  String get projectLabel => 'Projekt';

  @override
  String get listLabel => 'Liste';

  @override
  String get energyLabel => 'Energie';

  @override
  String get dueByLabel => 'Fällig bis';

  @override
  String get timeNeededLabel => 'Zeitbedarf';

  @override
  String get applyLabel => 'Übernehmen';

  @override
  String get exportRunning => 'Export läuft...';

  @override
  String get importRunning => 'Import läuft...';

  @override
  String exportSavedMessage(Object path) {
    return 'Export gespeichert unter $path';
  }

  @override
  String get importCompleteMessage => 'Import abgeschlossen';

  @override
  String get reviewNotesHint => 'Was lief gut? Was braucht Aufmerksamkeit?';

  @override
  String get statNextActions => 'Nächste Aktionen';

  @override
  String get statWaitingFor => 'Warten auf';

  @override
  String get statMaybe => 'Vielleicht';

  @override
  String get statDone => 'Erledigt';

  @override
  String get twoMinuteChip => '2-Min-Regel';

  @override
  String get quickCapturePrompt => 'Was geht dir durch den Kopf?';

  @override
  String get quickCaptureHint => 'Schnell festhalten und später verarbeiten';

  @override
  String get addToInbox => 'In Inbox legen';

  @override
  String get inboxHeroTitle => 'Gedanken parken';

  @override
  String get inboxHeroDescription => 'Fange alles ein, was dir begegnet. Verarbeite es später in Ruhe und bleibe im Flow.';

  @override
  String get exportLabel => 'Exportieren';

  @override
  String get importLabel => 'Importieren';

  @override
  String get aboutDescription => 'Eine kleine GTD‑App für Studierende.\n\nDieses Projekt ist Open Source.';

  @override
  String get aboutRepositoryTitle => 'Repository';

  @override
  String get aboutGithub => 'GitHub';

  @override
  String get aboutSupportTitle => 'Unterstütze das Projekt';

  @override
  String get aboutBuyMeCoffee => 'Buy Me a Coffee';

  @override
  String get aboutBuyMeCoffeeSubtitle => 'Unterstütze die Entwicklung via Buy Me a Coffee';

  @override
  String get searchTooltip => 'Suchen';

  @override
  String get aboutTooltip => 'Über';

  @override
  String get more => 'Mehr';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get minutesHint => 'Minuten';

  @override
  String get localeSystemLabel => 'System (Standard)';

  @override
  String get localeDeLabel => 'Deutsch (de_DE)';

  @override
  String get localeEnGbLabel => 'English (UK) en_GB';

  @override
  String get localeEnUsLabel => 'English (US) en_US';

  @override
  String get localeFrLabel => 'Français (fr_FR)';

  @override
  String overflowCount(Object count) {
    return '+$count';
  }

  @override
  String get onboardingTitle => 'Willkommen bei GTD Student';

  @override
  String get onboardingStep1Title => 'Schnell erfassen';

  @override
  String get onboardingStep1Body => 'Nutze den FAB, um Gedanken und Aufgaben schnell in deine Inbox zu erfassen.';

  @override
  String get onboardingStep2Title => 'Inbox verarbeiten';

  @override
  String get onboardingStep2Body => 'Entscheide für jeden Eintrag: sofort erledigen, delegieren, auf später verschieben oder löschen.';

  @override
  String get onboardingStep3Title => 'Organisieren & Review';

  @override
  String get onboardingStep3Body => 'Weise Aufgaben Projekten zu, setze Fälligkeitsdaten und prüfe wöchentlich den Fortschritt.';

  @override
  String get onboardingBack => 'Zurück';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingGetStarted => 'Los geht\'s';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get showOnboardingAgain => 'Tutorial erneut anzeigen';

  @override
  String get showOnboardingAgainTooltip => 'Tutorial zurücksetzen und erneut anzeigen';

  @override
  String get resetAppTitle => 'App zurücksetzen';

  @override
  String get resetAppDescription => 'Alle lokalen App‑Daten löschen (Tasks, Projekte, Inbox, Reviews) und alle Einstellungen zurücksetzen.';

  @override
  String get resetAppConfirm => 'Bist du sicher, dass du ALLE lokalen Daten unwiderruflich löschen möchtest?';

  @override
  String get resetAppButton => 'App zurücksetzen';

  @override
  String get resetAppDone => 'App zurückgesetzt';

  @override
  String get onboardingStep1Extra => 'Tipp: Halte Erfassungen kurz — Titel + 1‑Zeile Notiz reichen meist aus.';

  @override
  String get onboardingStep2Extra => 'Tipp: Triff schnelle Entscheidungen — dauert es <2 Minuten, erledige es direkt.';

  @override
  String get onboardingStep3Extra => 'Tipp: Plane eine wöchentliche Review‑Zeit ein, um Ordnung zu halten.';

  @override
  String get aboutLicenseTitle => 'Lizenz';

  @override
  String get aboutLicenseText => 'Dieses Projekt wird unter der MIT‑Lizenz verteilt. Siehe die LICENSE‑Datei für Details.';
}
