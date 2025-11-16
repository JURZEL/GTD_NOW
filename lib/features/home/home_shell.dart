import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

import '../actions/actions_page.dart';
import '../inbox/inbox_page.dart';
import '../projects/projects_page.dart';
import '../review/review_page.dart';
import '../search/gtd_search_delegate.dart';
import 'quick_capture_sheet.dart';
import '../settings/notifications_settings.dart';
import '../settings/about_page.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  // Titles are localized at build time using AppLocalizations

  @override
  Widget build(BuildContext context) {
    final pages = const [
      InboxPage(),
      ProjectsPage(),
      ActionsPage(),
      ReviewPage(),
    ];

    final loc = AppLocalizations.of(context)!;

    String title;
    switch (_index) {
      case 1:
        title = loc.navProjects;
        break;
      case 2:
        title = loc.navActions;
        break;
      case 3:
        title = loc.navReview;
        break;
      case 0:
      default:
        title = loc.navInbox;
    }

    return Scaffold(
      appBar: AppBar(
        // Use the app theme's title style for consistent typography on Android
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: GtdSearchDelegate(ref),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const NotificationsSettingsPage(),
              ));
            },
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.settingsTitle,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AboutPage(),
              ));
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      // Use a compact circular FAB (icon + tooltip) which is the preferred
      // primary action pattern on Android. The quick-capture sheet remains
      // available via the FAB tap.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickCapture(context),
        tooltip: loc.quickCapture,
        child: const Icon(Icons.flash_on),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(icon: Icon(Icons.inbox_outlined), label: loc.navInbox),
          NavigationDestination(icon: Icon(Icons.folder_outlined), label: loc.navProjects),
          NavigationDestination(icon: Icon(Icons.check_circle_outline), label: loc.navActions),
          NavigationDestination(icon: Icon(Icons.refresh), label: loc.navReview),
        ],
      ),
    );
  }

  Future<void> _showQuickCapture(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const QuickCaptureSheet(),
    );
  }
}
