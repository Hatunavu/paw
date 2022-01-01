import 'package:demo_git/features/setting/bloc/locale_state.dart';
import 'package:demo_git/shared/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(null));
  Future<void> setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;
    emit(LocaleState(locale));
  }
}
