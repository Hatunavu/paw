import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HealthBookButton extends StatelessWidget {
  VoidCallback onPress;
  HealthBookButton({Key key, @required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Center(
      child: InkWell(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              color: primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            text.health_book,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
