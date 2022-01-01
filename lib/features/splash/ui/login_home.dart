import 'package:demo_git/features/authentication/bloc/authentication/authentication_cubit.dart';
import 'package:demo_git/features/authentication/bloc/authentication/authentication_state.dart';
import 'package:demo_git/features/authentication/bloc/login/login_cubit.dart';
import 'package:demo_git/features/authentication/ui/login_page.dart';
import 'package:demo_git/features/fill_user/bloc/avt_picker_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/fill_user_cubit.dart';
import 'package:demo_git/features/fill_user/ui/fill_user_page.dart';
import 'package:demo_git/features/home/ui/home.dart';
import 'package:demo_git/features/profile/bloc/profile_cubit.dart';
import 'package:demo_git/features/splash/bloc/first_login_cubit.dart';
import 'package:demo_git/features/splash/bloc/first_login_state.dart';
import 'package:demo_git/features/splash/ui/splash_page.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key key}) : super(key: key);

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  UserRepository _userRepository;
  initState() {
    super.initState();
    _userRepository = context.read<UserRepositoryImplement>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, authenticationState) {
        if (authenticationState is AuthenticationStateUnauthenticated) {
          return BlocProvider(
            create: (context) => LoginCubit(_userRepository),
            child: BlocProvider(
              create: (context) => FirstLoginCubit(_userRepository),
              child: const LoginPage(),
            ),
          );
        } else if (authenticationState is AuthenticationStateAuthenticated) {
          return BlocProvider(
              create: (context) => FirstLoginCubit(_userRepository)..started(),
              child: BlocBuilder<FirstLoginCubit, FirstLoginState>(
                builder: (context, firstState) {
                  if (firstState is FirstLoginStateTrue) {
                    return MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (context) => AvtPickerCubit()),
                          BlocProvider(
                              create: (context) =>
                                  FillUserCubit(_userRepository)),
                        ],
                        child: const FillUserPage(
                          update: false,
                          userr: null,
                        ));
                  }
                  if (firstState is FirstLoginStateFalse) {
                    return BlocProvider(
                      create: (context) => ProfileCubit(_userRepository),
                      child: const Home(),
                    );
                  }
                  return const Scaffold();
                },
              ));
        } else {
          return const SplashPage();
        }
      },
    );
  }
}
