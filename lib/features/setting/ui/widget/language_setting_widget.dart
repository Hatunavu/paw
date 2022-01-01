import 'package:demo_git/features/setting/bloc/setting_cubit.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/locale_cubit.dart';

class LanguageSettingWidget extends StatefulWidget {
  final String content;
  LanguageSettingWidget({Key key, @required this.content}) : super(key: key);

  @override
  State<LanguageSettingWidget> createState() => _LanguageSettingWidgetState();
}

enum Language { english, vietnamese }

class _LanguageSettingWidgetState extends State<LanguageSettingWidget> {
  Language _lang;
  SettingCubit _settingCubit;
  LocaleCubit _localeCubit;

  @override
  void initState() {
    super.initState();
    _settingCubit = context.read<SettingCubit>();
    _localeCubit = context.read<LocaleCubit>();
  }

  @override
  Widget build(BuildContext context) {
    _lang = AppLocalizations.of(context).language == 'Language'
        ? Language.english
        : Language.vietnamese;
    return InkWell(
      onTap: () {},
      child: Container(
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 15, left: 10),
                  child: Icon(
                    Icons.language,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.content,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    const Text('VI'),
                    SizedBox(
                      width: 25,
                      child: Radio(
                          activeColor: primaryColor,
                          value: Language.vietnamese,
                          groupValue: _lang,
                          onChanged: (_) {
                            _settingCubit.setLang('vi');
                            _localeCubit.setLocale(const Locale('vi'));
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    const Text('EN'),
                    SizedBox(
                      width: 25,
                      child: Radio(
                          activeColor: primaryColor,
                          value: Language.english,
                          groupValue: _lang,
                          onChanged: (_) {
                            _settingCubit.setLang('en');
                            _localeCubit.setLocale(const Locale('en'));
                          }),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
