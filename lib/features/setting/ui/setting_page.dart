import 'package:demo_git/features/authentication/bloc/authentication/authentication_cubit.dart';
import 'package:demo_git/features/setting/bloc/location_setting_cubit.dart';
import 'package:demo_git/features/setting/bloc/setting_cubit.dart';
import 'package:demo_git/features/setting/ui/widget/enable_location_widget.dart';
import 'package:demo_git/features/setting/ui/widget/language_setting_widget.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/widgets/button.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AuthenticationCubit _authenticationCubit;
  UserRepository _userRepository;
  @override
  void initState() {
    super.initState();
    _userRepository = context.read<UserRepositoryImplement>();
    _authenticationCubit = context.read<AuthenticationCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: backgroundLogin,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            text.setting,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.3,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  BlocProvider(
                    create: (context) =>
                        LocationSettingCubit(userRepository: _userRepository),
                    child: const EnableLocationWidget(),
                  ),
                  const BuildDevider(),
                  BlocProvider(
                    create: (context) => SettingCubit(_userRepository),
                    child: LanguageSettingWidget(content: text.language),
                  ),
                  const BuildDevider(),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              ButtonWidget(
                  button: text.logout,
                  onPress: () async {
                    await _authenticationCubit.loggedOut();
                    await _userRepository.deleteFirstLogin();
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class BuildDevider extends StatelessWidget {
  const BuildDevider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1.0, color: Colors.black.withOpacity(.3)),
    );
  }
}
