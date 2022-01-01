import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/fill_user/bloc/avt_picker_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/avt_picker_state.dart';
import 'package:demo_git/features/fill_user/bloc/date_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/date_state.dart';
import 'package:demo_git/features/fill_user/bloc/fill_user_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/fill_user_state.dart';
import 'package:demo_git/features/fill_user/bloc/gender_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/gender_state.dart';
import 'package:demo_git/features/fill_user/ui/widget/date_picker_widget.dart';
import 'package:demo_git/features/fill_user/ui/widget/gender_picker_widget.dart';
import 'package:demo_git/features/splash/bloc/first_login_cubit.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/utils/function.dart';
import 'package:demo_git/shared/widgets/input_infor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class FillUserPage extends StatefulWidget {
  final bool update;
  final Userr userr;
  const FillUserPage({Key key, @required this.update, @required this.userr})
      : super(key: key);

  @override
  _FillUserPageState createState() => _FillUserPageState();
}

class _FillUserPageState extends State<FillUserPage> {
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _bossNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  AvtPickerCubit _avtPickerCubit;
  FirstLoginCubit _firstLoginCubit;
  FillUserCubit _fillUserCubit;
  bool get update => widget.update;
  Userr get userr => widget.userr;

  @override
  initState() {
    super.initState();
    _avtPickerCubit = context.read<AvtPickerCubit>();
    _firstLoginCubit = update ? null : context.read<FirstLoginCubit>();
    _fillUserCubit = context.read<FillUserCubit>();
    _petNameController.text = userr?.petName;
    _speciesController.text = userr?.species;
    _foodController.text = userr?.favoriteFood;
    _bossNameController.text = userr?.bossName;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () {
          unfocus(context);
        },
        child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => DateCubit()),
              BlocProvider(create: (context) => GenderCubit())
            ],
            child: BlocConsumer<FillUserCubit, FillUserState>(
                listener: (context, fillUserState) {
              if (fillUserState is FillUserStateLoading) {
                isLoading = true;
              } else if (fillUserState is FillUserStateSuccess) {
                isLoading = false;
                update
                    ? (ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(text.update_success),
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            )
                          ],
                        ),
                        backgroundColor: primaryColor,
                      )))
                    : null;
              }
            }, builder: (context, fillUserState) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.3,
                  automaticallyImplyLeading: false,
                  leading: update
                      ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      : null,
                  centerTitle: true,
                  title: Text(
                    update ? text.update_pet_infor : text.fill_pet_infor,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                backgroundColor: backgroundLogin,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        isLoading
                            ? LinearProgressIndicator(
                                color: primaryColor,
                                backgroundColor: backgroundLogin,
                              )
                            : const SizedBox(),
                        Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade200),
                                          child: BlocBuilder<AvtPickerCubit,
                                                  AvtPickerState>(
                                              builder:
                                                  (context, avtPickerState) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: avtPickerState
                                                          .imagePicked ==
                                                      null
                                                  ? update
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              userr.avatar,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              Shimmer
                                                                  .fromColors(
                                                            baseColor: Colors
                                                                .grey[300],
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100],
                                                            child: Container(
                                                              width: 100,
                                                              height: 100,
                                                              color:
                                                                  backgroundLogin,
                                                            ),
                                                          ),
                                                        )
                                                      : Image.asset(avatar_df)
                                                  : Image.file(
                                                      File(avtPickerState
                                                          .imagePicked.path),
                                                      fit: BoxFit.cover,
                                                    ),
                                            );
                                          })),
                                      Positioned(
                                          right: 5,
                                          bottom: 0,
                                          child: InkWell(
                                            onTap: () {
                                              unfocus(context);
                                              pickUpImage(
                                                  context, _avtPickerCubit);
                                            },
                                            child: Container(
                                              height: 28,
                                              width: 28,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white),
                                              child: Center(
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color(
                                                              0xff583da1)),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InputInfor(
                                    controller: _petNameController,
                                    label: text.username,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  DatePickerWidget(
                                    isHealth: false,
                                    title: text.date_of_birth,
                                    date: update ? userr.dateOfBirth : null,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GenderPickerWidget(
                                    userr: update ? userr : null,
                                    male: text.male,
                                    female: text.female,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InputInfor(
                                    controller: _speciesController,
                                    label: text.species,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InputInfor(
                                    controller: _foodController,
                                    label: text.favorite_food,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InputInfor(
                                    controller: _bossNameController,
                                    label: text.boss_name,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  BlocBuilder<AvtPickerCubit, AvtPickerState>(
                                      builder: (context, avtPickerState) {
                                    return BlocBuilder<GenderCubit,
                                            GenderState>(
                                        builder: (context, genderState) {
                                      return BlocBuilder<DateCubit, DateState>(
                                          builder: (context, dataState) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              unfocus(context);
                                              if (_formKey.currentState
                                                      .validate() &&
                                                  dataState.dateTime != null &&
                                                  genderState.gender != null) {
                                                await _fillUserCubit.fillUser(
                                                    petName:
                                                        _petNameController.text,
                                                    dateOfBirth:
                                                        dataState.dateTime,
                                                    gender: genderState.gender,
                                                    species:
                                                        _speciesController.text,
                                                    favoriteFood:
                                                        _foodController.text,
                                                    bossName:
                                                        _bossNameController
                                                            .text,
                                                    image: avtPickerState
                                                        .imagePicked,
                                                    avatar: update
                                                        ? userr.avatar
                                                        : null,
                                                    id: _firebaseAuth
                                                        .currentUser.uid);
                                                update
                                                    ? null
                                                    : await _firstLoginCubit
                                                        .isSecondLogin();
                                              }
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(primaryColor),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0),
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Text(
                                                update
                                                    ? text.update
                                                    : text.save,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    });
                                  })
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            })));
  }
}
