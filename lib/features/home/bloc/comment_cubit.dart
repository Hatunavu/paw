import 'package:demo_git/data/model/comment.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/home/bloc/comment_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/extension/noti_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentCubit extends Cubit<CommentState> {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CommentCubit(this._userRepository) : super(CommentStateInitial());
  Future<void> comment(
      {@required String postId,
      @required String comment,
      @required Post post,
      @required String uid,
      @required String notiId}) async {
    final Userr userr =
        await _userRepository.getUserr(_firebaseAuth.currentUser.uid);
    final bool isMainUser = uid == _firebaseAuth.currentUser.uid;

    await _userRepository.comment(
        postId: postId,
        comment: Comment(
            uid: userr.uid,
            comment: comment,
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
                notiId: notiId,
                type: NotiType.comment.type,
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
                caption: post?.caption ?? getPost.caption,
                postId: postId,
                comment: comment,
                createdPost: post?.createdAt ?? getPost.createdAt),
            uid: uid,
            notiId: notiId);
  }

  void getComment(String postId) {
    _userRepository.getComment(postId: postId).then((value) =>
        value.listen((snapshot) => emit(CommentStateSuccess(snapshot.docs))));
  }
}
