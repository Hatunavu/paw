import 'package:demo_git/features/authentication/bloc/authentication/authentication_cubit.dart';
import 'package:demo_git/features/authentication/bloc/login/login_cubit.dart';
import 'package:demo_git/features/authentication/bloc/login/login_state.dart';
import 'package:demo_git/features/splash/bloc/first_login_cubit.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widget/otp_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationCubit _authenticationCubit;
  LoginCubit _loginCubit;
  FirstLoginCubit _firstLoginCubit;
  final _phoneTextController = TextEditingController();
  bool error = false;
  bool otpError = false;
  String message = '';

  @override
  void initState() {
    _authenticationCubit = context.read<AuthenticationCubit>();
    _loginCubit = context.read<LoginCubit>();
    _firstLoginCubit = context.read<FirstLoginCubit>();
    super.initState();
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundLogin,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, loginState) {
            if (loginState is LoginStateLoading ||
                loginState is LoginStateOtpLoading) {
              _showDialog();
            } else if (loginState is LoginStateComplete) {
              _authenticationCubit.loggedIn();
              loginState.user.additionalUserInfo.isNewUser
                  ? _firstLoginCubit.isFirstLogin()
                  : _firstLoginCubit.isSecondLogin();

              Navigator.pop(context);
            } else if (loginState is LoginStateException) {
              Navigator.pop(context);
              message = loginState.message;
              error = true;
            } else if (loginState is LoginStateOtpException) {
              Navigator.pop(context);
              otpError = true;
              message = loginState.message;
            } else if (loginState is LoginStateBack) {
              message = '';
              error = false;
            }
          },
          builder: (context, loginState) {
            if (loginState is LoginStateOtpSent ||
                loginState is LoginStateOtpException ||
                loginState is LoginStateOtpLoading) {
              if (loginState is LoginStateOtpSent) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
              }
              return OtpWidget(
                onPress: () => _loginCubit.back(),
                error: otpError,
                message: message,
              );
            }
            return SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  TextEditingController().clear();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            logo1,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          AppLocalizations.of(context).welcome,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context).send_phone,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black38,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                cursorColor: primaryColor,
                                controller: _phoneTextController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: error
                                              ? Colors.red
                                              : Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: error
                                              ? Colors.red
                                              : Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                  // prefixText: '   (+84) ',
                                  // prefixStyle: const TextStyle(
                                  //     fontSize: 18,
                                  //     fontWeight: FontWeight.w600,
                                  //     color: Colors.black54),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 2, top: 12, bottom: 12),
                                    child: Text(
                                      '(+84)',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              error
                                  ? Text(
                                      message,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    )
                                  : const SizedBox(
                                      height: 7,
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _loginCubit.sentOtpEvent(
                                      '+84${_phoneTextController.value.text}',
                                    );
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            primaryColor),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(14.0),
                                    child: Text(
                                      AppLocalizations.of(context).login,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
