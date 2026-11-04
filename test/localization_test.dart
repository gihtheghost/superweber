import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superweber/core/localization/app_localizations.dart';
import 'package:superweber/core/theme/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('locale changes immediately and persists across app recreation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    Widget createApp() => ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const _LocaleTestApp(),
    );

    await tester.pumpWidget(createApp());

    expect(
      find.text('Criado por Ti Ribeiro Silvério e Giovanna Vieira Gaeta'),
      findsOneWidget,
    );
    expect(find.text('Dificuldade'), findsOneWidget);

    await tester.tap(find.text('Switch to English'));
    await tester.pumpAndSettle();

    expect(
      find.text('Created by Ti Ribeiro Silvério and Giovanna Vieira Gaeta'),
      findsOneWidget,
    );
    expect(find.text('Difficulty'), findsOneWidget);
    expect(prefs.getString('app_locale'), 'en');
    expect(prefs.getString('app_country'), 'US');

    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Created by Ti Ribeiro Silvério and Giovanna Vieira Gaeta'),
      findsOneWidget,
    );
    expect(find.text('Difficulty'), findsOneWidget);
  });
}

class _LocaleTestApp extends ConsumerWidget {
  const _LocaleTestApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(themeProvider).locale;

    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.authors),
                Text(l10n.difficulty),
                TextButton(
                  onPressed: () => ref
                      .read(themeProvider.notifier)
                      .setLocale(const Locale('en', 'US')),
                  child: const Text('Switch to English'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
