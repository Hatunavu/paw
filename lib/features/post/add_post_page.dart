import 'dart:io';

import 'package:demo_git/features/fill_user/bloc/avt_picker_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/avt_picker_state.dart';
import 'package:demo_git/features/post/bloc/add_post_cubit.dart';
import 'package:demo_git/features/post/bloc/add_post_state.dart';
import 'package:demo_git/features/post/bloc/location_cubit.dart';
import 'package:demo_git/features/post/bloc/location_state.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  AvtPickerCubit _avtPickerCubit;
  AddPostCubit _addPostCubit;
  LocationCubit _locationCubit;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool isLoading = false;
  String postId = const Uuid().v4();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _avtPickerCubit = context.read<AvtPickerCubit>();
    _addPostCubit = context.read<AddPostCubit>();
    _locationCubit = context.read<LocationCubit>();
  }

  void completeDiolog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              text,
              style: TextStyle(color: primaryColor),
            ),
            actions: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  backAddImage() {
    _avtPickerCubit.emit(AvtPickerState(null));
    _locationCubit.emit(LocationStateSuccess(''));
    _captionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvtPickerCubit, AvtPickerState>(
        builder: (context, avtPickerState) {
      return avtPickerState.imagePicked == null ? pickImage() : uploadPost();
    });
  }

  Widget pickImage() {
    final double width = MediaQuery.of(context).size.width;
    final text = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width - 40,
                child: Text(
                  text.lets_share,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              SvgPicture.asset(
                imagePost,
                width: width - 80,
                height: width - 80,
                color: primaryColor.withOpacity(0.3),
              ),
              RaisedButton(
                onPressed: () {
                  pickUpImage(context, _avtPickerCubit);
                },
                color: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  text.add_image,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadPost() {
    final text = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () {
          unfocus(context);
        },
        child: BlocConsumer<AddPostCubit, AddPostState>(
          listener: (context, postState) {
            if (postState is AddPostStateLoading) {
              isLoading = true;
            } else if (postState is AddPostStateSuccess) {
              isLoading = false;
              completeDiolog(text.post_success);
              backAddImage();
            }
          },
          builder: (context, postState) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: backAddImage,
                  ),
                  elevation: 0.3,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    text.create_post,
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: BlocBuilder<AvtPickerCubit, AvtPickerState>(
                            builder: (context, avtPickerState) {
                          return Center(
                              child: InkWell(
                            onTap: () async {
                              unfocus(context);
                              if (_formKey.currentState.validate()) {
                                await _addPostCubit.addPost(
                                    caption: _captionController.text,
                                    image: avtPickerState.imagePicked,
                                    location: _locationController.text,
                                    id: postId);
                                postId = const Uuid().v4();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                text.post,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ));
                        }))
                  ],
                ),
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      isLoading
                          ? LinearProgressIndicator(
                              color: primaryColor,
                              backgroundColor: backgroundLogin,
                            )
                          : const SizedBox(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return text.enter_something;
                                  }
                                  return null;
                                },
                                controller: _captionController,
                                maxLines: null,
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(0),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorStyle: const TextStyle(height: 0.3),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    border: InputBorder.none,
                                    hintText: text.say_sth),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  height:
                                      MediaQuery.of(context).size.width - 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: BlocBuilder<AvtPickerCubit,
                                          AvtPickerState>(
                                      builder: (context, avtPickerState) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.file(
                                        File(avtPickerState.imagePicked.path),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  })),
                              BlocConsumer<LocationCubit, LocationState>(
                                  listener: (context, locationState) {
                                if (locationState is LocationStateLoading) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _locationController.text = text.loading;
                                  });
                                } else if (locationState
                                    is LocationStateSuccess) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _locationController.text =
                                        locationState.location;
                                  });
                                }
                              }, builder: (context, locationState) {
                                return TextFormField(
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return text.enter_location;
                                    }
                                    return null;
                                  },
                                  controller: _locationController,
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                      errorStyle: const TextStyle(height: 0.3),
                                      errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: text.location,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.location_on,
                                        color: primaryColor,
                                      )),
                                );
                              }),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: RaisedButton.icon(
                                  onPressed: () {
                                    _locationCubit.getLocation();
                                    unfocus(context);
                                  },
                                  color: primaryColor,
                                  icon: const Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    text.use_current_locate,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ));
  }
}
