// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GTD Student';

  @override
  String get quickCapture => 'Quick capture';

  @override
  String get navInbox => 'Inbox';

  @override
  String get navProjects => 'Projects';

  @override
  String get navActions => 'Actions';

  @override
  String get navReview => 'Review';

  @override
  String get settingsTitle => 'Notifications';

  @override
  String get appearanceLabel => 'Appearance';

  @override
  String get edit => 'Edit';

  @override
  String get reschedule => 'Reschedule';

  @override
  String get markDone => 'Mark done';

  @override
  String get markUndone => 'Mark undone';

  @override
  String get snooze => 'Snooze';

  @override
  String get moveToProject => 'Move to project';

  @override
  String get showDetails => 'Show details';

  @override
  String get notificationsEnable => 'Enable notifications';

  @override
  String permissionsStatus(Object status) {
    return 'Permissions: $status';
  }

  @override
  String get requestPermissions => 'Request permissions';

  @override
  String get openSettings => 'Open settings';

  @override
  String get fallbackReminders => 'Fallback reminders (Windows/Fuchsia):';

  @override
  String get noFallbacks => 'No fallback reminders';

  @override
  String get clearAll => 'Clear all';

  @override
  String get appLanguage => 'App language';

  @override
  String appLanguageSet(Object locale) {
    return 'App language set: $locale';
  }

  @override
  String initializationFailed(Object error) {
    return 'Initialization failed: $error';
  }

  @override
  String get searchTasks => 'Tasks';

  @override
  String get searchNoResults => 'No results';

  @override
  String deadlineLabel(Object date) {
    return 'Deadline $date';
  }

  @override
  String dueLabel(Object date) {
    return 'Due $date';
  }

  @override
  String get createProject => 'Create project';

  @override
  String get noProjectsYet => 'No projects yet — create the first one!';

  @override
  String errorWith(Object error) {
    return 'Error: $error';
  }

  @override
  String openTasksCount(Object count) {
    return 'Open tasks ($count)';
  }

  @override
  String get noOpenTasks => 'No open tasks — nice!';

  @override
  String get dialogCreateProjectTitle => 'Create project';

  @override
  String get nameLabel => 'Name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDeleteTitle => 'Confirm delete';

  @override
  String confirmDeleteProject(Object name) {
    return 'Delete project \"$name\"?';
  }

  @override
  String projectDeleted(Object name) {
    return 'Project \"$name\" deleted';
  }

  @override
  String get chooseDate => 'Choose date';

  @override
  String get cancel => 'Cancel';

  @override
  String get saving => 'Saving...';

  @override
  String get save => 'Save';

  @override
  String get weeklyReviewTitle => 'Weekly review';

  @override
  String get weeklyReviewDescription => 'Clear your mind, review all projects and plan the next week.';

  @override
  String get startReview => 'Start review';

  @override
  String inboxHeader(Object count) {
    return 'Inbox ($count)';
  }

  @override
  String get inboxSubtitle => 'Empty the inbox regularly so nothing is lost.';

  @override
  String get emptyInbox => 'Empty inbox';

  @override
  String maybeLaterHeader(Object count) {
    return 'Maybe/Later ($count)';
  }

  @override
  String get reviewLog => 'Review Log';

  @override
  String get reviewNotesTitle => 'Review Notes';

  @override
  String get backupLabel => 'Backup';

  @override
  String capturedAtLabel(Object date) {
    return 'Captured: $date';
  }

  @override
  String get taskLabel => 'Task';

  @override
  String get somedayLabel => 'Maybe/Later';

  @override
  String get twoMinuteRuleTitle => '2-minute rule: do it now';

  @override
  String get twoMinuteRuleSubtitle => 'If it takes less time, mark it done immediately.';

  @override
  String get notifyOnDueTitle => 'Notify on due';

  @override
  String get notificationChannelDueName => 'Due dates';

  @override
  String get notificationChannelDueDescription => 'Notifications for upcoming tasks';

  @override
  String notificationDueTitle(Object title) {
    return 'Due: $title';
  }

  @override
  String get notificationDueBody => 'Keep going — you\'re almost done!';

  @override
  String get linuxNotificationActionOpen => 'Open';

  @override
  String get actionsStatusTitle => 'Status';

  @override
  String get useFabToCapture => 'Use the FAB to capture thoughts.';

  @override
  String get nextActionsTitle => 'Next actions';

  @override
  String get noActionsMessage => 'No tasks for current selection. Adjust filters.';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get filterByContext => 'Filter by context';

  @override
  String get energyLevel => 'Energy level';

  @override
  String get timeWindow => 'Time window';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes min';
  }

  @override
  String hoursLabel(Object hours) {
    return '$hours h';
  }

  @override
  String get permissionGranted => 'Granted';

  @override
  String get permissionDenied => 'Not granted';

  @override
  String get processTitle => 'Process';

  @override
  String get titleLabel => 'Title';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get contextLabel => 'Context';

  @override
  String get noProject => 'No project';

  @override
  String get projectsLoadError => 'Could not load projects';

  @override
  String get projectLabel => 'Project';

  @override
  String get listLabel => 'List';

  @override
  String get energyLabel => 'Energy';

  @override
  String get dueByLabel => 'Due by';

  @override
  String get timeNeededLabel => 'Time needed';

  @override
  String get applyLabel => 'Apply';

  @override
  String get exportRunning => 'Exporting...';

  @override
  String get importRunning => 'Importing...';

  @override
  String exportSavedMessage(Object path) {
    return 'Export saved to $path';
  }

  @override
  String get importCompleteMessage => 'Import completed';

  @override
  String get reviewNotesHint => 'What went well? What needs attention?';

  @override
  String get statNextActions => 'Next actions';

  @override
  String get statWaitingFor => 'Waiting for';

  @override
  String get statMaybe => 'Maybe';

  @override
  String get statDone => 'Done';

  @override
  String get twoMinuteChip => '2-min rule';

  @override
  String get quickCapturePrompt => 'What\'s on your mind?';

  @override
  String get quickCaptureHint => 'Capture quickly and process later';

  @override
  String get addToInbox => 'Add to inbox';

  @override
  String get inboxHeroTitle => 'Park your thoughts';

  @override
  String get inboxHeroDescription => 'Capture everything you encounter. Process it later and stay in flow.';

  @override
  String get exportLabel => 'Export';

  @override
  String get importLabel => 'Import';

  @override
  String get aboutDescription => 'A small GTD app for students.\n\nThis project is open source.';

  @override
  String get aboutRepositoryTitle => 'Repository';

  @override
  String get aboutGithub => 'GitHub';

  @override
  String get aboutSupportTitle => 'Support the project';

  @override
  String get aboutBuyMeCoffee => 'Buy me a coffee';

  @override
  String get aboutBuyMeCoffeeSubtitle => 'Support development via Buy Me a Coffee';

  @override
  String get searchTooltip => 'Search';

  @override
  String get aboutTooltip => 'About';

  @override
  String get more => 'More';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get minutesHint => 'Minutes';

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
  String get onboardingTitle => 'Welcome to GTD Student';

  @override
  String get onboardingStep1Title => 'Capture quickly';

  @override
  String get onboardingStep1Body => 'Use the FAB to quickly capture tasks and ideas into your Inbox.';

  @override
  String get onboardingStep2Title => 'Process your Inbox';

  @override
  String get onboardingStep2Body => 'Decide what each item means: do it, delegate it, defer it, or trash it.';

  @override
  String get onboardingStep3Title => 'Organize & Review';

  @override
  String get onboardingStep3Body => 'Assign tasks to projects, set due dates and review weekly to keep momentum.';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStep1Extra => 'Tip: Keep captures short — title and a 1‑line note is enough.';

  @override
  String get onboardingStep2Extra => 'Tip: Use quick decisions — if it takes <2 minutes, do it now.';

  @override
  String get onboardingStep3Extra => 'Tip: Schedule a weekly review time to keep the system clean.';

  @override
  String get aboutLicenseTitle => 'License';

  @override
  String get aboutLicenseText => 'This project is distributed under the MIT License. See the LICENSE file for details.';
}
