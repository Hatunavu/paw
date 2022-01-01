import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/fill_user/bloc/gender_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/gender_state.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderPickerWidget extends StatefulWidget {
  final Userr userr;
  final String male;
  final String female;
  GenderPickerWidget(
      {Key key,
      @required this.userr,
      @required this.male,
      @required this.female})
      : super(key: key);

  @override
  _GenderPickerWidgetState createState() => _GenderPickerWidgetState();
}

class _GenderPickerWidgetState extends State<GenderPickerWidget> {
  GenderCubit _genderCubit;
  Userr get userr => widget.userr;
  String get male => widget.male;
  String get female => widget.female;

  @override
  void initState() {
    super.initState();
    _genderCubit = context.read<GenderCubit>();
    userr != null ? _genderCubit.emit(GenderState(userr?.gender ?? 2)) : null;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return BlocBuilder<GenderCubit, GenderState>(
        builder: (context, genderState) {
      return Container(
        child: FormField(
          validator: (_) {
            if (genderState.gender == null) {
              return AppLocalizations.of(context).choose_something;
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: genderState.gender == null
                        ? Colors.grey[400]
                        : primaryColor),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: AppLocalizations.of(context).gender,
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 15, right: 10),
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                errorText: state.errorText,
                errorStyle: const TextStyle(fontSize: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: DropdownButton(
                  onTap: () => unfocus(context),
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  isExpanded: true,
                  value: genderState.gender,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.grey,
                  ),
                  underline: const SizedBox(),
                  onChanged: (int newValue) {
                    _genderCubit.updateGender(newValue);
                  },
                  items: <int>[1, 2].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value == 1 ? text.male : text.female),
                    );
                  }).toList()),
            );
          },
        ),
      );
    });
  }
}
