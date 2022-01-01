import 'package:demo_git/data/model/health_book.dart';
import 'package:demo_git/features/fill_user/bloc/date_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/date_state.dart';
import 'package:demo_git/features/fill_user/ui/widget/date_picker_widget.dart';
import 'package:demo_git/features/health_book/bloc/done_cubit.dart';
import 'package:demo_git/features/health_book/bloc/done_state.dart';
import 'package:demo_git/features/health_book/bloc/fill_health_cubit.dart';
import 'package:demo_git/features/health_book/bloc/fill_health_state.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/utils/function.dart';
import 'package:demo_git/shared/widgets/button.dart';
import 'package:demo_git/shared/widgets/input_infor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddHealthWidget extends StatefulWidget {
  final HealthBook health;
  final bool isUpdate;
  const AddHealthWidget(
      {Key key, @required this.health, @required this.isUpdate})
      : super(key: key);

  @override
  _AddHealthWidgetState createState() => _AddHealthWidgetState();
}

class _AddHealthWidgetState extends State<AddHealthWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FillHealthCubit _fillHealthCubit;
  DoneCubit _doneCubit;
  HealthBook get health => widget.health;
  var id = Uuid().v4();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fillHealthCubit = context.read<FillHealthCubit>();
    _doneCubit = context.read<DoneCubit>();
    health?.done != null ? _doneCubit.emit(DoneState(health.done)) : null;
    _titleController.text = health?.title;
    _addressController.text = health?.address;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () => unfocus(context),
        child: BlocBuilder<FillHealthCubit, FillHealthState>(
          builder: (context, fillState) {
            return Scaffold(
              backgroundColor: backgroundLogin,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.3,
                automaticallyImplyLeading: false,
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
                centerTitle: true,
                title: Text(
                  widget.isUpdate ? text.detail : text.create_a_new_schedule,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputInfor(
                            label: text.title, controller: _titleController),
                        const SizedBox(
                          height: 15,
                        ),
                        InputInfor(
                            label: text.address,
                            controller: _addressController),
                        const SizedBox(
                          height: 15,
                        ),
                        DatePickerWidget(
                          isHealth: true,
                          date: health?.schedule,
                          title: text.schedule,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<DoneCubit, DoneState>(
                            builder: (context, doneState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                text.accomplished,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              FlutterSwitch(
                                  width: 40.0,
                                  height: 20.0,
                                  activeColor: primaryColor,
                                  toggleSize: 15.0,
                                  value: doneState.done,
                                  onToggle: (val) {
                                    _doneCubit.updateDone(val);
                                  }),
                            ],
                          );
                        }),
                        const SizedBox(
                          height: 35,
                        ),
                        BlocBuilder<DoneCubit, DoneState>(
                            builder: (context, doneState) {
                          return BlocBuilder<DateCubit, DateState>(
                              builder: (context, dateState) {
                            return ButtonWidget(
                                button:
                                    widget.isUpdate ? text.update : text.create,
                                onPress: () async {
                                  unfocus(context);
                                  if (_formKey.currentState.validate() &&
                                      dateState.dateTime != null) {
                                    await _fillHealthCubit.fillHealth(
                                        createdAt:
                                            health?.createdAt ?? DateTime.now(),
                                        id: health?.id ?? id,
                                        title: _titleController.text,
                                        schedule: dateState.dateTime,
                                        address: _addressController.text,
                                        done: doneState.done,
                                        isUpdate: widget.isUpdate);
                                    id = const Uuid().v4();
                                    Navigator.pop(context);
                                  }
                                });
                          });
                        }),
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
