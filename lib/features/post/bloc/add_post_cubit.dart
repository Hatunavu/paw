import 'dart:io';

import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/post/bloc/add_post_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPostCubit extends Cubit<AddPostState> {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AddPostCubit(this._userRepository) : super(AddPostStateInitial());

  Future<void> addPost(
      {@required String caption,
      @required File image,
      @required String location,
      @required String id}) async {
    emit(AddPostStateLoading());
    final Userr userr =
        await _userRepository.getUserr(_firebaseAuth.currentUser.uid);
    final downloadUrl = image != null
        ? await _userRepository.uploadImage(image, id, 'post')
        : avt_df;
    final BaseUser user =
        BaseUser(uid: userr.uid, petName: userr.petName, avatar: userr.avatar);
    await _userRepository.addPostUser(UserPost(
        id: id,
        caption: caption,
        location: location,
        image: downloadUrl,
        createdAt: DateTime.now()));
    await _userRepository
        .addPost(
            post: Post(
                id: id,
                caption: caption,
                location: location,
                image: downloadUrl,
                createdAt: DateTime.now(),
                user: user),
            id: id)
        .then((value) => emit(AddPostStateSuccess()));
  }
}
