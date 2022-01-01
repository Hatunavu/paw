import 'package:demo_git/data/local/app_preference.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _goLoading() async {
    Future.delayed(const Duration(milliseconds: 2000), _routerPage);
  }

  _routerPage() async {
    final isFirst = await AppPreferences.isFirstInstall();
    if (isFirst) {
      AppRouter.routeToOnboarding(context);
    } else {
      if (mounted) {
        AppRouter.routeToLoginHome(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _goLoading();
    return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              logo1,
              color: Colors.white,
            ),
            const Text(
              'Paw',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.white,
                fontSize: 50,
              ),
            )
          ],
        ));
  }
}
