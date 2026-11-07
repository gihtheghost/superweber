// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'SuperWeber';

  @override
  String get authors =>
      'Criado por Ti Ribeiro Silvério e Giovanna Vieira Gaeta';

  @override
  String get loginTitle => 'Bem-vindo ao SuperWeber';

  @override
  String get selectLanguage => 'Idioma';

  @override
  String get portuguese => 'Português';

  @override
  String get english => 'Inglês';

  @override
  String get play => 'Jogar';

  @override
  String get settings => 'Configurações';

  @override
  String get help => 'Ajuda';

  @override
  String get signOut => 'Sair';

  @override
  String get backToLogin => 'Voltar para o login';

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get easy => 'Fácil';

  @override
  String get intermediate => 'Intermediário';

  @override
  String get advanced => 'Avançado';

  @override
  String get hard => 'Difícil';

  @override
  String get score => 'Carros Destruídos';

  @override
  String get lives => 'Vidas';

  @override
  String get timeRemaining => 'Tempo Restante';

  @override
  String get skip => 'Pular Placa';

  @override
  String get surrender => 'Desistir';

  @override
  String get verify => 'Verificar';

  @override
  String get clear => 'Limpar';

  @override
  String get gameOver => 'Fim de Jogo!';

  @override
  String get gameOverDescription =>
      'O Weber perdeu todas as vidas. Tente novamente!';

  @override
  String get restart => 'Jogar Novamente';

  @override
  String get themeMode => 'Modo do Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get fontSize => 'Tamanho da Fonte';

  @override
  String get fontFamily => 'Família da Fonte';

  @override
  String get seedColor => 'Cor Semente';

  @override
  String get sound => 'Efeitos Sonoros';

  @override
  String get soundOn => 'Som Ativado';

  @override
  String get soundOff => 'Som Desativado (Mudo)';

  @override
  String get helpTitle => 'Como Jogar';

  @override
  String get helpText =>
      'Você é Weber, um gato com poderes telecinéticos! Resolva a equação matemática da placa antes que o carro alcance você. Arraste os operadores para os espaços entre os dígitos fixos para formar uma igualdade verdadeira; a equação deve incluir \'=\'. Divisão por zero, resultados acima de 10.000 e divisões não inteiras fora do modo Fácil são rejeitados.';

  @override
  String get close => 'Fechar';

  @override
  String get errorInvalidStructure => 'Estrutura da equação inválida.';

  @override
  String get errorNeedOperator =>
      'Insira ao menos um operador entre cada par de dígitos.';

  @override
  String get errorNeedEquals =>
      'A equação precisa incluir um sinal de igual (=).';

  @override
  String get errorMultipleEquals => 'É permitido apenas um sinal de igual (=).';

  @override
  String get errorBothSidesRequired =>
      'A equação precisa ter termos nos dois lados do sinal de igual.';

  @override
  String get errorUnequalSides => 'Os dois lados da equação são diferentes.';

  @override
  String get errorInvalidExpression => 'Expressão matemática inválida.';

  @override
  String get errorUnexpectedTokens => 'Há símbolos adicionais inesperados.';

  @override
  String get errorSyntax => 'Sintaxe de equação inválida.';

  @override
  String get errorDivisionByZero => 'Divisão por zero não é permitida.';

  @override
  String get errorNonIntegerDivision =>
      'Divisão não inteira é permitida apenas no modo Fácil.';

  @override
  String get errorOverflow => 'O resultado excede o limite máximo de 10.000.';

  @override
  String get errorSquareRootDomain =>
      'Não é permitida a raiz quadrada de um número negativo.';

  @override
  String get errorFactorialDomain =>
      'O fatorial é definido apenas para inteiros não negativos.';

  @override
  String get errorRejectedAction =>
      'Ação rejeitada: excederia 10.000 ou causaria divisão por zero.';

  @override
  String get recordsTitle => 'Placas Resolvidas';

  @override
  String get loading => 'Carregando dados...';

  @override
  String get noRecords => 'Nenhuma placa resolvida ainda.';

  @override
  String plateLabel(String plate) {
    return 'Placa: $plate';
  }

  @override
  String get semConta => 'Não tem uma conta?';

  @override
  String get criaConta => 'Criar conta.';

  @override
  String get jaTemConta => 'Já tem uma conta?';

  @override
  String get login => 'Login';

  @override
  String get or => 'ou';
}
