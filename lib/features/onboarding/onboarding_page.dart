import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_student/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gtd_student/core/providers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _page = 0;
  bool _languagePickerShown = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    final navigator = Navigator.of(context);
    await ref.read(settingsRepositoryProvider).setOnboardingSeen(true);
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final steps = [
      _OnboardingStep(loc.onboardingStep1Title, loc.onboardingStep1Body, loc.onboardingStep1Extra, Icons.flash_on),
      _OnboardingStep(loc.onboardingStep2Title, loc.onboardingStep2Body, loc.onboardingStep2Extra, Icons.inbox),
      _OnboardingStep(loc.onboardingStep3Title, loc.onboardingStep3Body, loc.onboardingStep3Extra, Icons.list_alt),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.onboardingTitle),
        actions: [
          IconButton(
            onPressed: () => _finishOnboarding(context),
            icon: const Icon(Icons.close, size: 20),
            tooltip: loc.onboardingSkip,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: steps.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, index) {
                final s = steps[index];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(s.icon, size: 80, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 20),
                      Text(s.title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Text(s.body, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      if (s.extra.isNotEmpty) Text(s.extra, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    if (_page > 0) {
                      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    } else {
                      _finishOnboarding(context);
                    }
                  },
                  child: Text(_page > 0 ? AppLocalizations.of(context)!.onboardingBack : AppLocalizations.of(context)!.onboardingSkip),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: steps.length,
                  effect: WormEffect(
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_page < steps.length - 1) {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    } else {
                      _finishOnboarding(context);
                    }
                  },
                  child: Text(_page < steps.length - 1 ? AppLocalizations.of(context)!.onboardingNext : AppLocalizations.of(context)!.onboardingGetStarted.toUpperCase()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show language picker once before tutorial pages are shown.
    if (!_languagePickerShown) {
      _languagePickerShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLanguagePicker());
    }
  }

  Future<void> _showLanguagePicker() async {
    final loc = AppLocalizations.of(context)!;
    // Dialog with flag emoji and native language names. These labels are intentionally
    // the native names (Deutsch, English, Français) as requested by the user.
  final choice = await showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(loc.onboardingTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Deutsch — Bitte wähle die App‑Sprache.'),
            SizedBox(height: 6),
            Text('English — Please choose the app language.'),
            SizedBox(height: 6),
            Text("Français — Veuillez choisir la langue de l'application."),
          ],
        ),
          actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(AppLocalizations.of(context)!.onboardingSkip),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('de_DE'),
            child: Row(children: [SvgPicture.asset('assets/flags/de.svg', width: 24, height: 16), const SizedBox(width: 8), const Text('Deutsch')]),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('en_GB'),
            child: Row(children: [SvgPicture.asset('assets/flags/en_gb.svg', width: 24, height: 16), const SizedBox(width: 8), const Text('English')]),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('fr_FR'),
            child: Row(children: [SvgPicture.asset('assets/flags/fr.svg', width: 24, height: 16), const SizedBox(width: 8), const Text('Français')]),
          ),
        ],
      ),
    );

    if (choice != null) {
      await ref.read(appLocaleProvider.notifier).setLocale(choice);
      // Rebuild so AppLocalizations updates; the tutorial will now pick up the new locale.
      setState(() {});
    }
  }

  // removed custom dots in favor of smooth_page_indicator
}

class _OnboardingStep {
  final String title;
  final String body;
  final String extra;
  final IconData icon;
  _OnboardingStep(this.title, this.body, this.extra, this.icon);
}
