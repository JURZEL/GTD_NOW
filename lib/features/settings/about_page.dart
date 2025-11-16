import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gtd_student/l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(loc.appTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('A small GTD app for students.\n\nThis project is open source.'),
          const SizedBox(height: 12),
          Text('Repository', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            title: const Text('GitHub'),
            subtitle: const Text(_repoUrl),
            trailing: IconButton(icon: const Icon(Icons.open_in_new), onPressed: () => _launch(_repoUrl)),
            onTap: () => _launch(_repoUrl),
          ),
          const SizedBox(height: 8),
          Text('Support the project', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            title: const Text('Buy me a coffee'),
            subtitle: const Text('Support development via Buy Me a Coffee'),
            trailing: IconButton(icon: const Icon(Icons.coffee), onPressed: () => _launch(_buyMeCoffee)),
            onTap: () => _launch(_buyMeCoffee),
          ),
          const SizedBox(height: 12),
          Text('License', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('This project is distributed under the MIT License. See the LICENSE file for details.'),
        ],
      ),
    );
  }
}
