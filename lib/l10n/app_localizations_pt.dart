// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get helloWorld => 'Olá mundo!';

  @override
  String get home => 'Receitas';

  @override
  String get favorites => 'Favoritas';

  @override
  String get settings => 'Configurações';

  @override
  String get appearance => 'Aparência';

  @override
  String get system => 'Sistema';

  @override
  String get dark => 'Escuro';

  @override
  String get light => 'Claro';

  @override
  String get search => 'Pesquisar';

  @override
  String get add => 'Adicionar';

  @override
  String get recipe => 'Receita';

  @override
  String get create => 'Adicionar';

  @override
  String empty_error(String field) {
    return '$field não pode estar vazio';
  }

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrição';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get steps => 'Etapas';

  @override
  String get category => 'Categoria';

  @override
  String get prep_time => 'Tempo de preparação';

  @override
  String get cook_time => 'Tempo de cozimento';

  @override
  String get total_time => 'Tempo total';

  @override
  String get category_info_1 =>
      'Se você não adicionar uma categoria, a receita será adicionada à categoria \"Sem categoria\".';

  @override
  String get category_info_2 =>
      'Você pode editar a receita e adicionar uma categoria mais tarde.';

  @override
  String get close => 'Fechar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get no_category => 'Sem categoria';

  @override
  String get confirm_deletion_title => 'Confirmar exclusão';

  @override
  String delition_confirmation(String type) {
    return 'Tem certeza de que deseja excluir a $type typeName?';
  }

  @override
  String get deletion_info =>
      'Se houver alguma receita associada a esta categoria, ela será categorizada em \"Sem categoria\".';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get category_empty => 'Nenhuma categoria registrada';

  @override
  String smt_name(String something) {
    return 'Nome da $something';
  }

  @override
  String get description_placeholder => 'Fale um pouco sobre a receita...';

  @override
  String get recipe_empty => 'Nenhuma receita cadatrada';

  @override
  String get favorite_empty => 'Nenhuma receita favorita';

  @override
  String get minutes => 'minutos';

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get rating => 'Avaliação';
}
