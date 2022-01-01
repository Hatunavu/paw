import 'package:demo_git/data/model/base_activity.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/home/bloc/like_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/extension/noti_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeCubit extends Cubit<LikeState> {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  LikeCubit(this._userRepository) : super(LikeStateInitial());
  Future<void> likePost(
      {@required String postId,
      @required String uid,
      @required Post post}) async {
    final Userr userr =
        await _userRepository.getUserr(_firebaseAuth.currentUser.uid);
    final bool isMainUser = uid == _firebaseAuth.currentUser.uid;
    await _userRepository.likePost(
        postId: postId,
        liked: BaseActivity(
            uid: userr.uid,
            petName: userr.petName,
            avatar: userr.avatar,
            createdAt: DateTime.now()));
    isMainUser ? null : await _userRepository.addUnread(uid);
    final Userr userrp = isMainUser
        ? null
        : await _userRepository.getUserr(post?.user?.uid ?? uid);
    final Post getPost = await _userRepository.getPost(postId);

    isMainUser
        ? null
        : await _userRepository.addNoti(
            notification: Notificationn(
                notiId: _firebaseAuth.currentUser.uid,
                type: NotiType.like.type,
                read: false,
                createdAt: DateTime.now(),
                userPush: BaseUser(
                    uid: userr.uid,
                    petName: userr.petName,
                    avatar: userr.avatar),
                userPull: BaseUser(
                    uid: userrp.uid,
                    petName: userrp.petName,
                    avatar: userrp.avatar),
                image: post?.image ?? getPost.image,
                postId: postId,
                caption: post?.caption ?? getPost.caption,
                createdPost: post?.createdAt ?? getPost.createdAt,
                comment: ''),
            uid: uid,
            notiId: _firebaseAuth.currentUser.uid);
  }

  Future<void> dislikePost(
      {@required String postId, @required String uid}) async {
    final bool isMainUser = uid == _firebaseAuth.currentUser.uid;
    await _userRepository.dislikePost(postId: postId);
    final Userr userr = await _userRepository.getUserr(uid);
    isMainUser
        ? null
        : userr.unreadNoti > 0
            ? await _userRepository.removeUnread(uid)
            : null;
    await _userRepository.removeNoti(
        notiId: _firebaseAuth.currentUser.uid, uid: uid);
  }

  void getLiked(String postId) {
    bool isLiked = false;
    _userRepository.getLiked(postId).then((value) => value.listen((snapshot) {
          if (snapshot.docs == null || snapshot.docs.isEmpty) {
            isLiked = false;
          } else {
            for (final like in snapshot.docs) {
              if (like?.id == _firebaseAuth.currentUser.uid) {
                isLiked = true;
                break;
              } else {
                isLiked = false;
              }
            }
          }
          emit(LikeStateSuccess(snapshot.docs, isLiked));
        }));
  }
}
