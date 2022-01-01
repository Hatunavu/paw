import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/local/app_preference.dart';
import 'package:demo_git/data/model/base_activity.dart';
import 'package:demo_git/data/model/health_book.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:demo_git/data/model/comment.dart';
import 'package:demo_git/data/model/location.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/data/remote/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class UserRepository {
  Future<void> sentOtp(
      {@required String phoneNumber,
      @required Duration timeOut,
      @required PhoneVerificationFailed phoneVerificationFailed,
      @required PhoneVerificationCompleted phoneVerificationCompleted,
      @required PhoneCodeSent phoneCodeSent,
      @required PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout});
  Future<UserCredential> verifyAndLogin(String verificationId, String smsCode);
  Future<void> signOut();
  Future<User> getUser();
  Future<void> getLang();
  Future<void> setLang(String lang);
  Future<void> setFirstLogin(bool isFirstLogin);
  Future<void> deleteFirstLogin();
  Future<void> fillUser({@required Userr userr});
  Future<void> addPost({@required Post post, @required String id});
  Future<String> uploadImage(File image, String id, String type);
  Future<List> getSearchUserr(String searchText);
  Future<void> addPostUser(UserPost postUser);
  Future<Userr> getUserr(String uid);
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getProfile(String uid);
  Future<List> getPosts();
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getPostUser(String uid);
  Future<List> getNextPost(List documentList);
  Future<void> likePost(
      {@required String postId, @required BaseActivity liked});
  Future<void> dislikePost({@required String postId});
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getComment(
      {@required String postId});
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getLiked(String postId);
  Future<void> comment({@required String postId, @required Comment comment});
  Future<void> follow({@required BaseActivity follower, @required String uid});
  Future<void> followOwn(
      {@required BaseActivity follower, @required String uid});
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getFollower(
      {@required String uid});
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getFollowing(
      {@required String uid});
  Future<void> unFollow({@required String uid});
  Future<void> addUnread(String uid);
  Future<void> removeUnread(String uid);
  Future<void> readNoti();
  Future<void> addNoti(
      {@required Notificationn notification,
      @required String uid,
      @required String notiId});
  Future<void> removeNoti({@required String notiId, @required String uid});
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNoti();
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNextNoti(
      List documentList);
  Future<void> readNotification({@required String id});
  Future<void> enableLocation({@required Locationn locationn});
  Future<void> disableLocation();
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getLocation();
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getHealth();
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNextHealth(
      List documentList);
  Future<void> fillHealth(
      {@required HealthBook healthBook,
      @required String id,
      @required bool isUpdate});
  Future<Post> getPost(String postId);
}

class UserRepositoryImplement implements UserRepository {
  final _firebseProvider = FirebaseProvider();
  @override
  Future<void> sentOtp(
          {@required String phoneNumber,
          @required Duration timeOut,
          @required PhoneVerificationFailed phoneVerificationFailed,
          @required PhoneVerificationCompleted phoneVerificationCompleted,
          @required PhoneCodeSent phoneCodeSent,
          @required PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout}) =>
      _firebseProvider.sentOtp(
          phoneNumber: phoneNumber,
          timeOut: timeOut,
          phoneVerificationFailed: phoneVerificationFailed,
          phoneVerificationCompleted: phoneVerificationCompleted,
          phoneCodeSent: phoneCodeSent,
          autoRetrievalTimeout: autoRetrievalTimeout);

  @override
  Future<UserCredential> verifyAndLogin(
          String verificationId, String smsCode) =>
      _firebseProvider.verifyAndLogin(verificationId, smsCode);

  @override
  Future<void> signOut() => _firebseProvider.signOut();

  @override
  Future<User> getUser() => _firebseProvider.getUser();
  @override
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getProfile(
          String uid) =>
      _firebseProvider.getProfile(uid);

  @override
  Future<void> getLang() => AppPreferences.getLanguage();

  @override
  Future<void> setLang(String lang) => AppPreferences.setLanguage(lang);

  @override
  Future<void> setFirstLogin(bool isFirstLogin) =>
      AppPreferences.setFirstLogin(isFirstLogin);

  @override
  Future<void> deleteFirstLogin() => AppPreferences.deleleFirstLogin();

  @override
  Future<void> fillUser({@required Userr userr}) =>
      _firebseProvider.fillUser(userr);

  @override
  Future<String> uploadImage(File image, String id, String type) =>
      _firebseProvider.uploadImage(image, id, type);

  @override
  Future<List> getSearchUserr(String searchText) async {
    final _allResults = await _firebseProvider.getSearchUserr(searchText);
    final List showResults = [];
    if (searchText != '') {
      for (final snapshot in _allResults) {
        if (searchText != '') {
          final Userr userr = Userr.fromDoc(snapshot);
          final petName = userr.petName.toLowerCase();
          if (petName.contains(searchText.toLowerCase())) {
            showResults.add(snapshot);
          }
        }
      }
    }
    return showResults;
  }

  @override
  Future<void> addPost({@required Post post, @required String id}) =>
      _firebseProvider.addPost(post, id);

  @override
  Future<void> addPostUser(UserPost postUser) =>
      _firebseProvider.addPostUser(postUser);

  @override
  Future<Userr> getUserr(String uid) => _firebseProvider.getUserr(uid);

  @override
  Future<List> getPosts() => _firebseProvider.getPosts();

  @override
  Future<void> likePost(
          {@required String postId, @required BaseActivity liked}) =>
      _firebseProvider.likePost(postId, liked);

  @override
  Future<void> dislikePost({String postId}) =>
      _firebseProvider.dislikePost(postId);

  @override
  Future<void> comment({String postId, Comment comment}) =>
      _firebseProvider.comment(postId, comment);

  @override
  Future<List> getNextPost(List documentList) =>
      _firebseProvider.getNextPost(documentList);

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getComment(
          {String postId}) =>
      _firebseProvider.getComment(postId);

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getLiked(String postId) =>
      _firebseProvider.getLiked(postId);

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getPostUser(String uid) =>
      _firebseProvider.getPostUser(uid);

  @override
  Future<void> follow(
          {@required BaseActivity follower, @required String uid}) =>
      _firebseProvider.follow(follower, uid);

  @override
  Future<void> followOwn({BaseActivity follower, String uid}) =>
      _firebseProvider.followOwn(follower, uid);

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getFollower(
          {String uid}) =>
      _firebseProvider.getFollower(uid);

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getFollowing(
          {String uid}) =>
      _firebseProvider.getFollowing(uid);

  @override
  Future<void> unFollow({String uid}) {
    _firebseProvider.unFollow(uid);
    _firebseProvider.unFollowOwn(uid);
  }

  @override
  Future<void> addUnread(String uid) => _firebseProvider.addUnread(uid);

  @override
  Future<void> removeUnread(String uid) => _firebseProvider.removeUnread(uid);

  @override
  Future<void> readNoti() => _firebseProvider.readNoti();

  @override
  Future<void> addNoti(
          {@required Notificationn notification,
          @required String uid,
          @required String notiId}) =>
      _firebseProvider.addNoti(notification, uid, notiId);

  @override
  Future<void> removeNoti({String notiId, String uid}) =>
      _firebseProvider.removeNoti(notiId, uid);

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNextNoti(
          List documentList) =>
      _firebseProvider.getNextNoti(documentList);

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNoti() =>
      _firebseProvider.getNoti();

  @override
  Future<void> readNotification({@required String id}) =>
      _firebseProvider.readNotification(id);

  @override
  Future<void> enableLocation({@required Locationn locationn}) =>
      _firebseProvider.enableLocation(locationn);

  @override
  Future<void> disableLocation() => _firebseProvider.disableLocation();

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getLocation() =>
      _firebseProvider.getLocation();
  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getHealth() =>
      _firebseProvider.getHealth();

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNextHealth(
          List documentList) =>
      _firebseProvider.getNextHealth(documentList);

  @override
  Future<void> fillHealth(
          {@required HealthBook healthBook,
          @required String id,
          @required bool isUpdate}) =>
      _firebseProvider.fillHealth(healthBook, id, isUpdate);

  @override
  Future<Post> getPost(String postId) => _firebseProvider.getPost(postId);
}
