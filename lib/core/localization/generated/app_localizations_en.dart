// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SuperWeber';

  @override
  String get authors =>
      'Created by Ti Ribeiro Silvério and Giovanna Vieira Gaeta';

  @override
  String get loginTitle => 'Welcome to SuperWeber';

  @override
  String get selectLanguage => 'Language';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get play => 'Play';

  @override
  String get settings => 'Settings';

  @override
  String get help => 'Help';

  @override
  String get signOut => 'Sign out';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get hard => 'Hard';

  @override
  String get score => 'Cars Destroyed';

  @override
  String get lives => 'Lives';

  @override
  String get timeRemaining => 'Time Remaining';

  @override
  String get skip => 'Skip Plate';

  @override
  String get surrender => 'Give Up';

  @override
  String get verify => 'Verify';

  @override
  String get clear => 'Clear';

  @override
  String get gameOver => 'Game Over!';

  @override
  String get gameOverDescription => 'Weber lost all nine lives. Try again!';

  @override
  String get restart => 'Play Again';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get fontSize => 'Font Size';

  @override
  String get fontFamily => 'Font Family';

  @override
  String get seedColor => 'Seed Color';

  @override
  String get sound => 'Sound Effects';

  @override
  String get soundOn => 'Sound On';

  @override
  String get soundOff => 'Sound Off (Muted)';

  @override
  String get helpTitle => 'How to Play';

  @override
  String get helpText =>
      'You are Weber, a cat with telekinetic powers! Solve the math equation on the plate before the car reaches you. Drag operators into the slots between the fixed digits to form a true equality; the equation must include \'=\'. Division by zero, results over 10,000, and non-integer divisions outside Easy mode are rejected.';

  @override
  String get close => 'Close';

  @override
  String get errorInvalidStructure => 'Invalid equation structure.';

  @override
  String get errorNeedOperator =>
      'Insert at least one operator between every pair of digits.';

  @override
  String get errorNeedEquals => 'The equation must include an equals sign (=).';

  @override
  String get errorMultipleEquals => 'Only one equals sign (=) is allowed.';

  @override
  String get errorBothSidesRequired =>
      'The equation must have terms on both sides of the equals sign.';

  @override
  String get errorUnequalSides =>
      'The two sides of the equation are not equal.';

  @override
  String get errorInvalidExpression => 'Invalid mathematical expression.';

  @override
  String get errorUnexpectedTokens => 'Unexpected extra tokens.';

  @override
  String get errorSyntax => 'Invalid equation syntax.';

  @override
  String get errorDivisionByZero => 'Division by zero is not allowed.';

  @override
  String get errorNonIntegerDivision =>
      'Non-integer division is only allowed in Easy mode.';

  @override
  String get errorOverflow => 'The result exceeds the maximum limit of 10,000.';

  @override
  String get errorSquareRootDomain =>
      'The square root of a negative number is not allowed.';

  @override
  String get errorFactorialDomain =>
      'Factorial is only defined for non-negative integers.';

  @override
  String get errorRejectedAction =>
      'Action rejected: it would exceed 10,000 or divide by zero.';

  @override
  String get recordsTitle => 'Solved Plates';

  @override
  String get loading => 'Loading data...';

  @override
  String get noRecords => 'No solved plates yet.';

  @override
  String plateLabel(String plate) {
    return 'Plate: $plate';
  }

  @override
  String get semConta => 'Don\'t have an account?';

  @override
  String get criaConta => 'Create an account.';

  @override
  String get jaTemConta => 'Already have an account?';

  @override
  String get login => 'Login';

  @override
  String get or => 'or';
}
