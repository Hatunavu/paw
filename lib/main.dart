import 'package:demo_git/features/setting/bloc/locale_state.dart';
import 'package:demo_git/features/splash/ui/splash_page.dart';
import 'package:demo_git/shared/bloc/simple_bloc_observer.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/data/local/app_preference.dart';
import 'package:demo_git/shared/l10n/l10n.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/authentication/bloc/authentication/authentication_cubit.dart';
import 'features/setting/bloc/locale_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final String lang = await AppPreferences.getLanguage();
  runApp(MyApp(
    lang: lang,
  ));
}

class MyApp extends StatelessWidget {
  final String lang;
  const MyApp({Key key, @required this.lang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => UserRepositoryImplement(),
        child: BlocProvider(
            create: (context) =>
                AuthenticationCubit(context.read<UserRepositoryImplement>())
                  ..started(),
            child: BlocProvider(
              create: (context) => LocaleCubit(),
              child: BlocBuilder<LocaleCubit, LocaleState>(
                  builder: (context, state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(primaryColor: primaryColor),
                  home: const SplashPage(),
                  supportedLocales: L10n.all,
                  locale: state.locale == null
                      ? lang == null
                          ? state.locale
                          : Locale(lang)
                      : state.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                );
              }),
            )));
  }
}
