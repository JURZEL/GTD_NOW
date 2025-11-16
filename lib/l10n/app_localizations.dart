import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GTD Student'**
  String get appTitle;

  /// No description provided for @quickCapture.
  ///
  /// In en, this message translates to:
  /// **'Quick capture'**
  String get quickCapture;

  /// No description provided for @navInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get navInbox;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get navActions;

  /// No description provided for @navReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsTitle;

  /// No description provided for @appearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceLabel;
  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @reschedule.
  String get reschedule;

  /// No description provided for @markDone.
  String get markDone;

  /// No description provided for @markUndone.
  String get markUndone;

  /// No description provided for @snooze.
  String get snooze;

  /// No description provided for @moveToProject.
  String get moveToProject;

  /// No description provided for @showDetails.
  String get showDetails;

  /// No description provided for @notificationsEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get notificationsEnable;

  /// No description provided for @permissionsStatus.
  ///
  /// In en, this message translates to:
  /// **'Permissions: {status}'**
  String permissionsStatus(Object status);

  /// No description provided for @requestPermissions.
  ///
  /// In en, this message translates to:
  /// **'Request permissions'**
  String get requestPermissions;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @fallbackReminders.
  ///
  /// In en, this message translates to:
  /// **'Fallback reminders (Windows/Fuchsia):'**
  String get fallbackReminders;

  /// No description provided for @noFallbacks.
  ///
  /// In en, this message translates to:
  /// **'No fallback reminders'**
  String get noFallbacks;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @appLanguageSet.
  ///
  /// In en, this message translates to:
  /// **'App language set: {locale}'**
  String appLanguageSet(Object locale);

  /// No description provided for @initializationFailed.
  ///
  /// In en, this message translates to:
  /// **'Initialization failed: {error}'**
  String initializationFailed(Object error);

  /// No description provided for @searchTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get searchTasks;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get searchNoResults;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline {date}'**
  String deadlineLabel(Object date);

  /// No description provided for @dueLabel.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueLabel(Object date);

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create project'**
  String get createProject;

  /// No description provided for @noProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No projects yet — create the first one!'**
  String get noProjectsYet;

  /// No description provided for @errorWith.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWith(Object error);

  /// No description provided for @openTasksCount.
  ///
  /// In en, this message translates to:
  /// **'Open tasks ({count})'**
  String openTasksCount(Object count);

  /// No description provided for @noOpenTasks.
  ///
  /// In en, this message translates to:
  /// **'No open tasks — nice!'**
  String get noOpenTasks;

  /// No description provided for @dialogCreateProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Create project'**
  String get dialogCreateProjectTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete project \"{name}\"?'**
  String confirmDeleteProject(Object name);

  /// No description provided for @projectDeleted.
  ///
  /// In en, this message translates to:
  /// **'Project \"{name}\" deleted'**
  String projectDeleted(Object name);

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @weeklyReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly review'**
  String get weeklyReviewTitle;

  /// No description provided for @weeklyReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Clear your mind, review all projects and plan the next week.'**
  String get weeklyReviewDescription;

  /// No description provided for @startReview.
  ///
  /// In en, this message translates to:
  /// **'Start review'**
  String get startReview;

  /// No description provided for @inboxHeader.
  ///
  /// In en, this message translates to:
  /// **'Inbox ({count})'**
  String inboxHeader(Object count);

  /// No description provided for @inboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Empty the inbox regularly so nothing is lost.'**
  String get inboxSubtitle;

  /// No description provided for @emptyInbox.
  ///
  /// In en, this message translates to:
  /// **'Empty inbox'**
  String get emptyInbox;

  /// No description provided for @maybeLaterHeader.
  ///
  /// In en, this message translates to:
  /// **'Maybe/Later ({count})'**
  String maybeLaterHeader(Object count);

  /// No description provided for @reviewLog.
  ///
  /// In en, this message translates to:
  /// **'Review Log'**
  String get reviewLog;

  /// No description provided for @reviewNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Notes'**
  String get reviewNotesTitle;

  /// No description provided for @backupLabel.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupLabel;

  /// No description provided for @capturedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Captured: {date}'**
  String capturedAtLabel(Object date);

  /// No description provided for @taskLabel.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskLabel;

  /// No description provided for @somedayLabel.
  ///
  /// In en, this message translates to:
  /// **'Maybe/Later'**
  String get somedayLabel;

  /// No description provided for @twoMinuteRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'2-minute rule: do it now'**
  String get twoMinuteRuleTitle;

  /// No description provided for @twoMinuteRuleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If it takes less time, mark it done immediately.'**
  String get twoMinuteRuleSubtitle;

  /// No description provided for @notifyOnDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Notify on due'**
  String get notifyOnDueTitle;

  /// No description provided for @useFabToCapture.
  ///
  /// In en, this message translates to:
  /// **'Use the FAB to capture thoughts.'**
  String get useFabToCapture;

  /// No description provided for @nextActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Next actions'**
  String get nextActionsTitle;

  /// No description provided for @noActionsMessage.
  ///
  /// In en, this message translates to:
  /// **'No tasks for current selection. Adjust filters.'**
  String get noActionsMessage;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @filterByContext.
  ///
  /// In en, this message translates to:
  /// **'Filter by context'**
  String get filterByContext;

  /// No description provided for @energyLevel.
  ///
  /// In en, this message translates to:
  /// **'Energy level'**
  String get energyLevel;

  /// No description provided for @timeWindow.
  ///
  /// In en, this message translates to:
  /// **'Time window'**
  String get timeWindow;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesLabel(Object minutes);

  /// No description provided for @hoursLabel.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String hoursLabel(Object hours);

  /// No description provided for @permissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get permissionGranted;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Not granted'**
  String get permissionDenied;

  /// No description provided for @processTitle.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get processTitle;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @contextLabel.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get contextLabel;

  /// No description provided for @noProject.
  ///
  /// In en, this message translates to:
  /// **'No project'**
  String get noProject;

  /// No description provided for @projectsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load projects'**
  String get projectsLoadError;

  /// No description provided for @projectLabel.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projectLabel;

  /// No description provided for @listLabel.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listLabel;

  /// No description provided for @energyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energyLabel;

  /// No description provided for @dueByLabel.
  ///
  /// In en, this message translates to:
  /// **'Due by'**
  String get dueByLabel;

  /// No description provided for @timeNeededLabel.
  ///
  /// In en, this message translates to:
  /// **'Time needed'**
  String get timeNeededLabel;

  /// No description provided for @applyLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyLabel;

  /// No description provided for @exportRunning.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exportRunning;

  /// No description provided for @importRunning.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importRunning;

  /// No description provided for @exportSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Export saved to {path}'**
  String exportSavedMessage(Object path);

  /// No description provided for @importCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Import completed'**
  String get importCompleteMessage;

  /// No description provided for @reviewNotesHint.
  ///
  /// In en, this message translates to:
  /// **'What went well? What needs attention?'**
  String get reviewNotesHint;

  /// No description provided for @statNextActions.
  ///
  /// In en, this message translates to:
  /// **'Next actions'**
  String get statNextActions;

  /// No description provided for @statWaitingFor.
  ///
  /// In en, this message translates to:
  /// **'Waiting for'**
  String get statWaitingFor;

  /// No description provided for @statMaybe.
  ///
  /// In en, this message translates to:
  /// **'Maybe'**
  String get statMaybe;

  /// No description provided for @statDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statDone;

  /// No description provided for @twoMinuteChip.
  ///
  /// In en, this message translates to:
  /// **'2-min rule'**
  String get twoMinuteChip;

  /// No description provided for @quickCapturePrompt.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get quickCapturePrompt;

  /// No description provided for @quickCaptureHint.
  ///
  /// In en, this message translates to:
  /// **'Capture quickly and process later'**
  String get quickCaptureHint;

  /// No description provided for @addToInbox.
  ///
  /// In en, this message translates to:
  /// **'Add to inbox'**
  String get addToInbox;

  /// No description provided for @inboxHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Park your thoughts'**
  String get inboxHeroTitle;

  /// No description provided for @inboxHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Capture everything you encounter. Process it later and stay in flow.'**
  String get inboxHeroDescription;

  /// Label for the export button in the backup section
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportLabel;

  /// Label for the import button in the backup section
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
