import 'package:demo_git/features/fill_user/bloc/date_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/date_state.dart';
import 'package:demo_git/shared/extension/format_date.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime date;
  final String title;
  final bool isHealth;
  const DatePickerWidget(
      {Key key,
      @required this.title,
      @required this.date,
      @required this.isHealth})
      : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateCubit _dateCubit;
  DateTime get date => widget.date;
  initState() {
    super.initState();
    _dateCubit = context.read<DateCubit>();
    date != null ? _dateCubit.emit(DateState(date)) : null;
  }

  _dayPicker(DateTime dateTime) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return CalendarDatePicker(
            initialDate: dateTime,
            firstDate: DateTime(1990),
            lastDate: widget.isHealth ? DateTime(2099) : DateTime.now(),
            onDateChanged: (DateTime newDate) {
              _dateCubit.updateDate(newDate);
              Navigator.pop(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateCubit, DateState>(builder: (context, dateState) {
      return InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
          _dayPicker(dateState.dateTime ?? DateTime.now());
        },
        child: Container(
            child: FormField(
          validator: (_) {
            if (dateState.dateTime == null) {
              return AppLocalizations.of(context).choose_something;
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.grey,
                ),
                labelStyle: TextStyle(
                    color: dateState.dateTime == null
                        ? Colors.grey[400]
                        : primaryColor),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: widget.title,
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 15, right: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                errorText: state.errorText,
                errorStyle: const TextStyle(fontSize: 10),
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Container(
                child: Text(
                    dateState?.dateTime != null
                        ? FormatDate(dateState?.dateTime).format()
                        : '',
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            );
          },
        )),
      );
    });
  }
}
