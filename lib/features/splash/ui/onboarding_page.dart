import 'package:demo_git/data/local/app_preference.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _toHomePage() async {
      await AppPreferences.setFirstInstall();
      AppRouter.routeToLoginHome(context);
    }

    final text = AppLocalizations.of(context);

    return Scaffold(
      body: IntroductionScreen(
        color: primaryColor,
        showNextButton: true,
        next: const Icon(Icons.arrow_forward),
        pages: [
          PageViewModel(
              image: Image.asset(pet1),
              title: text.connect,
              body: text.connect_desc,
              decoration: getPageDecoration()),
          PageViewModel(
              image: Image.asset(pet2),
              title: text.profile,
              body: text.profile_desc,
              decoration: getPageDecoration()),
          PageViewModel(
              image: Image.asset(pet3),
              title: text.health,
              body: text.health_desc,
              decoration: getPageDecoration()),
        ],
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: primaryColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
        done: Container(
          height: 30,
          width: MediaQuery.of(context).size.width / 5,
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Text(
              text.start,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        onDone: _toHomePage,
        showSkipButton: true,
        onSkip: _toHomePage,
        skip: Text(text.skip),
        globalBackgroundColor: Colors.white,
      ),
    );
  }

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(
            color: primaryColor, fontSize: 30, fontWeight: FontWeight.w600),
        descriptionPadding: const EdgeInsets.symmetric(horizontal: 20),
        bodyTextStyle: const TextStyle(color: Colors.black54, fontSize: 25),
      );
}
