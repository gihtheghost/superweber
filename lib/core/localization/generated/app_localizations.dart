import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pt'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SuperWeber'**
  String get appTitle;

  /// No description provided for @authors.
  ///
  /// In en, this message translates to:
  /// **'Created by Ti Ribeiro Silvério and Giovanna Vieira Gaeta'**
  String get authors;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SuperWeber'**
  String get loginTitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get selectLanguage;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Cars Destroyed'**
  String get score;

  /// No description provided for @lives.
  ///
  /// In en, this message translates to:
  /// **'Lives'**
  String get lives;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip Plate'**
  String get skip;

  /// No description provided for @surrender.
  ///
  /// In en, this message translates to:
  /// **'Give Up'**
  String get surrender;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over!'**
  String get gameOver;

  /// No description provided for @gameOverDescription.
  ///
  /// In en, this message translates to:
  /// **'Weber lost all nine lives. Try again!'**
  String get gameOverDescription;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get restart;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @fontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamily;

  /// No description provided for @seedColor.
  ///
  /// In en, this message translates to:
  /// **'Seed Color'**
  String get seedColor;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get sound;

  /// No description provided for @soundOn.
  ///
  /// In en, this message translates to:
  /// **'Sound On'**
  String get soundOn;

  /// No description provided for @soundOff.
  ///
  /// In en, this message translates to:
  /// **'Sound Off (Muted)'**
  String get soundOff;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get helpTitle;

  /// No description provided for @helpText.
  ///
  /// In en, this message translates to:
  /// **'You are Weber, a cat with telekinetic powers! Solve the math equation on the plate before the car reaches you. Drag operators into the slots between the fixed digits to form a true equality; the equation must include \'=\'. Division by zero, results over 10,000, and non-integer divisions outside Easy mode are rejected.'**
  String get helpText;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @errorInvalidStructure.
  ///
  /// In en, this message translates to:
  /// **'Invalid equation structure.'**
  String get errorInvalidStructure;

  /// No description provided for @errorNeedOperator.
  ///
  /// In en, this message translates to:
  /// **'Insert at least one operator between every pair of digits.'**
  String get errorNeedOperator;

  /// No description provided for @errorNeedEquals.
  ///
  /// In en, this message translates to:
  /// **'The equation must include an equals sign (=).'**
  String get errorNeedEquals;

  /// No description provided for @errorMultipleEquals.
  ///
  /// In en, this message translates to:
  /// **'Only one equals sign (=) is allowed.'**
  String get errorMultipleEquals;

  /// No description provided for @errorBothSidesRequired.
  ///
  /// In en, this message translates to:
  /// **'The equation must have terms on both sides of the equals sign.'**
  String get errorBothSidesRequired;

  /// No description provided for @errorUnequalSides.
  ///
  /// In en, this message translates to:
  /// **'The two sides of the equation are not equal.'**
  String get errorUnequalSides;

  /// No description provided for @errorInvalidExpression.
  ///
  /// In en, this message translates to:
  /// **'Invalid mathematical expression.'**
  String get errorInvalidExpression;

  /// No description provided for @errorUnexpectedTokens.
  ///
  /// In en, this message translates to:
  /// **'Unexpected extra tokens.'**
  String get errorUnexpectedTokens;

  /// No description provided for @errorSyntax.
  ///
  /// In en, this message translates to:
  /// **'Invalid equation syntax.'**
  String get errorSyntax;

  /// No description provided for @errorDivisionByZero.
  ///
  /// In en, this message translates to:
  /// **'Division by zero is not allowed.'**
  String get errorDivisionByZero;

  /// No description provided for @errorNonIntegerDivision.
  ///
  /// In en, this message translates to:
  /// **'Non-integer division is only allowed in Easy mode.'**
  String get errorNonIntegerDivision;

  /// No description provided for @errorOverflow.
  ///
  /// In en, this message translates to:
  /// **'The result exceeds the maximum limit of 10,000.'**
  String get errorOverflow;

  /// No description provided for @errorSquareRootDomain.
  ///
  /// In en, this message translates to:
  /// **'The square root of a negative number is not allowed.'**
  String get errorSquareRootDomain;

  /// No description provided for @errorFactorialDomain.
  ///
  /// In en, this message translates to:
  /// **'Factorial is only defined for non-negative integers.'**
  String get errorFactorialDomain;

  /// No description provided for @errorRejectedAction.
  ///
  /// In en, this message translates to:
  /// **'Action rejected: it would exceed 10,000 or divide by zero.'**
  String get errorRejectedAction;

  /// No description provided for @recordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Solved Plates'**
  String get recordsTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loading;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No solved plates yet.'**
  String get noRecords;

  /// No description provided for @plateLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate: {plate}'**
  String plateLabel(String plate);

  /// No description provided for @semConta.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get semConta;

  /// No description provided for @criaConta.
  ///
  /// In en, this message translates to:
  /// **'Create an account.'**
  String get criaConta;

  /// No description provided for @jaTemConta.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get jaTemConta;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
