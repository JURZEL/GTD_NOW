import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';
import 'package:gtd_student/core/providers.dart';
import 'package:gtd_student/features/onboarding/onboarding_page.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  static const _repoUrl = 'https://github.com/JURZEL/GTD_NOW';
  static const _buyMeCoffee = 'https://www.buymeacoffee.com/jurzel';

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // ignore: avoid_print
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(loc.appTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(loc.aboutDescription),
          const SizedBox(height: 12),
          Text(loc.aboutRepositoryTitle, style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            title: Text(loc.aboutGithub),
            subtitle: const Text(_repoUrl),
            trailing: IconButton(icon: const Icon(Icons.open_in_new), onPressed: () => _launch(_repoUrl)),
            onTap: () => _launch(_repoUrl),
          ),
          const SizedBox(height: 8),
          Text(loc.aboutSupportTitle, style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            title: Text(loc.aboutBuyMeCoffee),
            subtitle: Text(loc.aboutBuyMeCoffeeSubtitle),
            trailing: IconButton(icon: const Icon(Icons.coffee), onPressed: () => _launch(_buyMeCoffee)),
            onTap: () => _launch(_buyMeCoffee),
          ),
          const SizedBox(height: 12),
          Text(loc.aboutLicenseTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(loc.aboutLicenseText),
          const SizedBox(height: 12),
          // Show onboarding again for users who want to re-run the tutorial
          ListTile(
            title: Text(AppLocalizations.of(context)!.showOnboardingAgain),
            subtitle: Text(AppLocalizations.of(context)!.showOnboardingAgainTooltip),
            leading: const Icon(Icons.school),
            onTap: () async {
              // reset the flag so onboarding appears again
              final navigator = Navigator.of(context);
              await ref.read(settingsRepositoryProvider).setOnboardingSeen(false);
              await navigator.push(MaterialPageRoute(builder: (_) => const OnboardingPage()));
            },
          ),
        ],
      ),
    );
  }
}
