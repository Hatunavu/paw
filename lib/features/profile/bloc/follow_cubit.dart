import 'package:demo_git/data/model/base_activity.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/profile/bloc/follow_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/extension/noti_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowCubit extends Cubit<FollowState> {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FollowCubit(this._userRepository) : super(FollowStateInitial());
  Future<void> follow({@required String uid, Userr userrFollowing}) async {
    final Userr userr =
        await _userRepository.getUserr(_firebaseAuth.currentUser.uid);

    await _userRepository.follow(
        follower: BaseActivity(
            uid: userr.uid,
            petName: userr.petName,
            avatar: userr.avatar,
            createdAt: DateTime.now()),
        uid: uid);
    await _userRepository.followOwn(
        follower: BaseActivity(
            uid: userrFollowing.uid,
            petName: userrFollowing.petName,
            avatar: userrFollowing.avatar,
            createdAt: DateTime.now()),
        uid: userrFollowing.uid);
    await _userRepository.addUnread(uid);
    await _userRepository.addNoti(
        notification: Notificationn(
            notiId: 'f${userr.uid}',
            caption: '',
            createdPost: DateTime.now(),
            type: NotiType.follow.type,
            read: false,
            createdAt: DateTime.now(),
            userPush: BaseUser(
                uid: userr.uid, petName: userr.petName, avatar: userr.avatar),
            userPull: BaseUser(uid: '', petName: '', avatar: ''),
            image: '',
            postId: '',
            comment: ''),
        uid: uid,
        notiId: 'f${userr.uid}');
  }

  Future<void> unFollow(
      {@required String uid, @required Userr userrFollowing}) async {
    await _userRepository.unFollow(uid: uid);
    userrFollowing.unreadNoti == 0
        ? null
        : await _userRepository.removeUnread(uid);
    await _userRepository.removeNoti(
        notiId: 'f${_firebaseAuth.currentUser.uid}', uid: uid);
  }

  void getFollower({@required String uid}) {
    bool isFollowing;
    _userRepository
        .getFollower(uid: uid)
        .then((value) => value.listen((snapshot) {
              if (snapshot.docs == null || snapshot.docs.isEmpty) {
                isFollowing = false;
              } else {
                for (final follow in snapshot.docs) {
                  if (follow?.id == _firebaseAuth.currentUser.uid) {
                    isFollowing = true;
                    break;
                  } else {
                    isFollowing = false;
                  }
                }
              }
              emit(FollowStateSuccess(snapshot.docs, isFollowing));
            }));
  }
}
