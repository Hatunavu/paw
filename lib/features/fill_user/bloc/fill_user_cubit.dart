import 'dart:io';

import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/fill_user/bloc/fill_user_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FillUserCubit extends Cubit<FillUserState> {
  final UserRepository _userRepository;
  FillUserCubit(this._userRepository) : super(FillUserStateInitial());

  Future<void> fillUser(
      {@required String petName,
      @required DateTime dateOfBirth,
      @required int gender,
      @required String species,
      @required String favoriteFood,
      @required String bossName,
      @required File image,
      @required String avatar,
      @required String id}) async {
    emit(FillUserStateLoading());
    final downloadUrl = image != null
        ? await _userRepository.uploadImage(image, id, 'avt')
        : avatar ?? avt_df;
    await _userRepository
        .fillUser(
            userr: Userr(
                uid: id,
                petName: petName,
                dateOfBirth: dateOfBirth,
                gender: gender,
                species: species,
                favoriteFood: favoriteFood,
                bossName: bossName,
                avatar: downloadUrl,
                unreadNoti: 0,
                shareLocation: false))
        .then((value) => emit(FillUserStateSuccess()));
  }
}
