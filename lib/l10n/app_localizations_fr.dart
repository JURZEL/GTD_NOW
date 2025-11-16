// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'GTD Étudiant';

  @override
  String get quickCapture => 'Saisie rapide';

  @override
  String get navInbox => 'Boîte de réception';

  @override
  String get navProjects => 'Projets';

  @override
  String get navActions => 'Actions';

  @override
  String get navReview => 'Revue';

  @override
  String get settingsTitle => 'Notifications';

  @override
  String get appearanceLabel => 'Apparence';

  @override
  String get edit => 'Modifier';

  @override
  String get reschedule => 'Replanifier';

  @override
  String get markDone => 'Marquer comme fait';

  @override
  String get markUndone => 'Annuler comme fait';

  @override
  String get snooze => 'Snooze';

  @override
  String get moveToProject => 'Déplacer vers un projet';

  @override
  String get showDetails => 'Afficher les détails';

  @override
  String get notificationsEnable => 'Activer les notifications';

  @override
  String permissionsStatus(Object status) {
    return 'Autorisations : $status';
  }

  @override
  String get requestPermissions => 'Demander les autorisations';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get fallbackReminders => 'Rappels de secours (Windows/Fuchsia) :';

  @override
  String get noFallbacks => 'Aucun rappel de secours';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get appLanguage => 'Langue de l\'application';

  @override
  String appLanguageSet(Object locale) {
    return 'Langue de l\'application définie : $locale';
  }

  @override
  String initializationFailed(Object error) {
    return 'Échec de l\'initialisation : $error';
  }

  @override
  String get searchTasks => 'Tâches';

  @override
  String get searchNoResults => 'Aucun résultat';

  @override
  String deadlineLabel(Object date) {
    return 'Date limite $date';
  }

  @override
  String dueLabel(Object date) {
    return 'À faire $date';
  }

  @override
  String get createProject => 'Créer un projet';

  @override
  String get noProjectsYet => 'Aucun projet pour l\'instant — créez le premier !';

  @override
  String errorWith(Object error) {
    return 'Erreur : $error';
  }

  @override
  String openTasksCount(Object count) {
    return 'Tâches ouvertes ($count)';
  }

  @override
  String get noOpenTasks => 'Aucune tâche ouverte — super !';

  @override
  String get dialogCreateProjectTitle => 'Créer un projet';

  @override
  String get nameLabel => 'Nom';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirmDeleteTitle => 'Confirmer la suppression';

  @override
  String confirmDeleteProject(Object name) {
    return 'Supprimer le projet \"$name\" ?';
  }

  @override
  String projectDeleted(Object name) {
    return 'Projet \"$name\" supprimé';
  }

  @override
  String get chooseDate => 'Choisir une date';

  @override
  String get cancel => 'Annuler';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get save => 'Enregistrer';

  @override
  String get weeklyReviewTitle => 'Revue hebdomadaire';

  @override
  String get weeklyReviewDescription => 'Dégagez votre esprit, passez en revue tous les projets et planifiez la semaine suivante.';

  @override
  String get startReview => 'Commencer la revue';

  @override
  String inboxHeader(Object count) {
    return 'Boîte de réception ($count)';
  }

  @override
  String get inboxSubtitle => 'Videz la boîte de réception régulièrement pour ne rien perdre.';

  @override
  String get emptyInbox => 'Vider la boîte';

  @override
  String maybeLaterHeader(Object count) {
    return 'Peut-être/Plus tard ($count)';
  }

  @override
  String get reviewLog => 'Journal de revue';

  @override
  String get reviewNotesTitle => 'Notes de revue';

  @override
  String get backupLabel => 'Sauvegarde';

  @override
  String capturedAtLabel(Object date) {
    return 'Enregistré : $date';
  }

  @override
  String get taskLabel => 'Tâche';

  @override
  String get somedayLabel => 'Peut-être/Plus tard';

  @override
  String get twoMinuteRuleTitle => 'Règle des 2 minutes : faites-le maintenant';

  @override
  String get twoMinuteRuleSubtitle => 'Si cela prend moins de temps, marquez-le comme terminé immédiatement.';

  @override
  String get notifyOnDueTitle => 'Notifier à l\'échéance';

  @override
  String get notificationChannelDueName => 'Échéances';

  @override
  String get notificationChannelDueDescription => 'Notifications pour les tâches à venir';

  @override
  String notificationDueTitle(Object title) {
    return 'À faire : $title';
  }

  @override
  String get notificationDueBody => 'Continuez — vous y êtes presque !';

  @override
  String get linuxNotificationActionOpen => 'Ouvrir';

  @override
  String get actionsStatusTitle => 'Statut';

  @override
  String get useFabToCapture => 'Utilisez le FAB pour capturer des idées.';

  @override
  String get nextActionsTitle => 'Actions suivantes';

  @override
  String get noActionsMessage => 'Aucune tâche pour la sélection actuelle. Ajustez les filtres.';

  @override
  String get calendarTitle => 'Calendrier';

  @override
  String get filterByContext => 'Filtrer par contexte';

  @override
  String get energyLevel => 'Niveau d\'énergie';

  @override
  String get timeWindow => 'Fenêtre temporelle';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes min';
  }

  @override
  String hoursLabel(Object hours) {
    return '$hours h';
  }

  @override
  String get permissionGranted => 'Accordé';

  @override
  String get permissionDenied => 'Non accordé';

  @override
  String get processTitle => 'Traiter';

  @override
  String get titleLabel => 'Titre';

  @override
  String get descriptionOptional => 'Description (optionnelle)';

  @override
  String get contextLabel => 'Contexte';

  @override
  String get noProject => 'Aucun projet';

  @override
  String get projectsLoadError => 'Impossible de charger les projets';

  @override
  String get projectLabel => 'Projet';

  @override
  String get listLabel => 'Liste';

  @override
  String get energyLabel => 'Énergie';

  @override
  String get dueByLabel => 'À faire avant';

  @override
  String get timeNeededLabel => 'Temps nécessaire';

  @override
  String get applyLabel => 'Appliquer';

  @override
  String get exportRunning => 'Export en cours...';

  @override
  String get importRunning => 'Import en cours...';

  @override
  String exportSavedMessage(Object path) {
    return 'Export enregistré dans $path';
  }

  @override
  String get importCompleteMessage => 'Import terminé';

  @override
  String get reviewNotesHint => 'Qu\'est-ce qui a bien fonctionné ? Qu\'est-ce qui nécessite de l\'attention ?';

  @override
  String get statNextActions => 'Actions suivantes';

  @override
  String get statWaitingFor => 'En attente';

  @override
  String get statMaybe => 'Peut-être';

  @override
  String get statDone => 'Terminé';

  @override
  String get twoMinuteChip => 'Règle des 2 min';

  @override
  String get quickCapturePrompt => 'Qu\'est-ce qui vous préoccupe ?';

  @override
  String get quickCaptureHint => 'Saisir rapidement et traiter plus tard';

  @override
  String get addToInbox => 'Ajouter à la boîte';

  @override
  String get inboxHeroTitle => 'Garez vos pensées';

  @override
  String get inboxHeroDescription => 'Capturez tout ce que vous rencontrez. Traitez-le plus tard et restez concentré.';

  @override
  String get exportLabel => 'Exporter';

  @override
  String get importLabel => 'Importer';

  @override
  String get aboutDescription => 'Une petite application GTD pour les étudiants.\n\nCe projet est open source.';

  @override
  String get aboutRepositoryTitle => 'Dépôt';

  @override
  String get aboutGithub => 'GitHub';

  @override
  String get aboutSupportTitle => 'Soutenir le projet';

  @override
  String get aboutBuyMeCoffee => 'Buy Me a Coffee';

  @override
  String get aboutBuyMeCoffeeSubtitle => 'Soutenez le développement via Buy Me a Coffee';

  @override
  String get searchTooltip => 'Rechercher';

  @override
  String get aboutTooltip => 'À propos';

  @override
  String get more => 'Plus';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get minutesHint => 'Minutes';

  @override
  String get localeSystemLabel => 'Système (par défaut)';

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
  String get onboardingTitle => 'Bienvenue dans GTD Student';

  @override
  String get onboardingStep1Title => 'Saisir rapidement';

  @override
  String get onboardingStep1Body => 'Utilisez le FAB pour enregistrer rapidement tâches et idées dans votre Boîte de réception.';

  @override
  String get onboardingStep2Title => 'Traitez votre Boîte';

  @override
  String get onboardingStep2Body => 'Décidez pour chaque élément: faire, déléguer, différer ou supprimer.';

  @override
  String get onboardingStep3Title => 'Organiser & Revue';

  @override
  String get onboardingStep3Body => 'Attribuez des tâches à des projets, définissez des dates d\'échéance et révisez chaque semaine.';

  @override
  String get onboardingBack => 'Retour';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get showOnboardingAgain => 'Montrer le tutoriel à nouveau';

  @override
  String get showOnboardingAgainTooltip => 'Réinitialiser et afficher le tutoriel';

  @override
  String get resetAppTitle => 'Réinitialiser l\'application';

  @override
  String get resetAppDescription => 'Supprimer toutes les données locales de l\'application (tâches, projets, boîte de réception, revues) et réinitialiser les paramètres par défaut.';

  @override
  String get resetAppConfirm => 'Êtes‑vous sûr de vouloir supprimer définitivement toutes les données locales ? Cette action est irréversible.';

  @override
  String get resetAppButton => 'Réinitialiser';

  @override
  String get resetAppDone => 'Réinitialisation terminée';

  @override
  String get onboardingStep1Extra => 'Astuce : gardez les saisies courtes — titre + une ligne suffisent souvent.';

  @override
  String get onboardingStep2Extra => 'Astuce : prenez des décisions rapides — si c\'est <2 minutes, faites‑le tout de suite.';

  @override
  String get onboardingStep3Extra => 'Astuce : réservez un créneau hebdomadaire pour la revue afin de rester organisé.';

  @override
  String get aboutLicenseTitle => 'Licence';

  @override
  String get aboutLicenseText => 'Ce projet est distribué sous la licence MIT. Voir le fichier LICENSE pour les détails.';
}
