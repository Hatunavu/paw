import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/base_activity.dart';
import 'package:demo_git/data/model/health_book.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:demo_git/data/model/comment.dart';
import 'package:demo_git/data/model/location.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final locationRef = FirebaseFirestore.instance.collection('around');
final storageRef = FirebaseStorage.instance.ref();

class FirebaseProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> sentOtp(
      {@required String phoneNumber,
      @required Duration timeOut,
      @required PhoneVerificationFailed phoneVerificationFailed,
      @required PhoneVerificationCompleted phoneVerificationCompleted,
      @required PhoneCodeSent phoneCodeSent,
      @required PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout}) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
        timeout: const Duration(seconds: 30));
  }

  Future<UserCredential> verifyAndLogin(
      String verificationId, String smsCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    return _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<void> signOut() {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> fillUser(Userr userr) {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .set(userr.toJson())
        .then((value) => print('done'))
        .onError((error, stackTrace) => print('error ' + error))
        .whenComplete(() => print('when complete'));
  }

  Future<void> addPost(Post post, String id) {
    return postsRef.doc(id).set(post.toJson());
  }

  Future<void> addPostUser(UserPost postUser) {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('posts')
        .add(postUser.toJson());
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getPostUser(
      String uid) async {
    return usersRef
        .doc(uid)
        .collection('posts')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<String> uploadImage(File image, String id, String type) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final Im.Image imageFile = Im.decodeImage(image.readAsBytesSync());
    final compressImageFile = File('$path/img_$id.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    final UploadTask uploadTask =
        storageRef.child('${type}_$id.jpg').putFile(compressImageFile);
    final String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<Userr> getUserr(String uid) async {
    final DocumentSnapshot doc = await usersRef.doc(uid).get();
    return Userr.fromDoc(doc);
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getProfile(
      String uid) async {
    return usersRef.doc(uid).snapshots();
  }

  Future<List> getSearchUserr(String searchText) async {
    final userrs = await usersRef
        .where('pet_name', isGreaterThanOrEqualTo: searchText.toUpperCase())
        .get();
    return userrs.docs;
  }

  Future<List> getPosts() async {
    final posts =
        await postsRef.orderBy('created_at', descending: true).limit(5).get();
    return posts.docs;
  }

  Future<Post> getPost(String postId) async {
    final result = await postsRef.doc(postId).get();
    return Post.fromDoc(result);
  }

  Future<List> getNextPost(List documentList) async {
    final posts = await postsRef
        .orderBy('created_at', descending: true)
        .startAfterDocument(documentList.last)
        .limit(5)
        .get();
    return posts.docs;
  }

  Future<void> likePost(
    String postId,
    BaseActivity liked,
  ) async {
    return postsRef
        .doc(postId)
        .collection('liked')
        .doc(_firebaseAuth.currentUser.uid)
        .set(liked.toJson());
  }

  Future<void> dislikePost(String postId) async {
    return postsRef
        .doc(postId)
        .collection('liked')
        .doc(_firebaseAuth.currentUser.uid)
        .delete();
  }

  Future<void> comment(String postId, Comment comment) {
    return postsRef
        .doc(postId)
        .collection('comments')
        .doc()
        .set(comment.toJson());
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getComment(
      String postId) async {
    return postsRef
        .doc(postId)
        .collection('comments')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getLiked(
      String postId) async {
    return postsRef.doc(postId).collection('liked').snapshots();
  }

  Future<void> follow(BaseActivity follower, String uid) async {
    return usersRef
        .doc(uid)
        .collection('followers')
        .doc(_firebaseAuth.currentUser.uid)
        .set(follower.toJson());
  }

  Future<void> unFollow(String uid) async {
    return usersRef
        .doc(uid)
        .collection('followers')
        .doc(_firebaseAuth.currentUser.uid)
        .delete();
  }

  Future<void> unFollowOwn(String uid) async {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('following')
        .doc(uid)
        .delete();
  }

  Future<void> followOwn(BaseActivity follower, String uid) async {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('following')
        .doc(uid)
        .set(follower.toJson());
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getFollower(
      String uid) async {
    return usersRef.doc(uid).collection('followers').snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getFollowing(
      String uid) async {
    return usersRef.doc(uid).collection('following').snapshots();
  }

  Future<void> addUnread(String uid) async {
    return usersRef.doc(uid).update({'unread_noti': FieldValue.increment(1)});
  }

  Future<void> removeUnread(String uid) async {
    return usersRef.doc(uid).update({'unread_noti': FieldValue.increment(-1)});
  }

  Future<void> readNoti() async {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .update({'unread_noti': 0});
  }

  Future<void> addNoti(
      Notificationn notification, String uid, String notiId) async {
    return usersRef
        .doc(uid)
        .collection('notification')
        .doc(notiId)
        .set(notification.toJson());
  }

  Future<void> removeNoti(String notiId, String uid) async {
    return usersRef.doc(uid).collection('notification').doc(notiId).delete();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNoti() async {
    final notis = usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('notification')
        .orderBy('created_at', descending: true)
        .limit(15)
        .snapshots();
    return notis;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNextNoti(
      List documentList) async {
    final notis = usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('notification')
        .orderBy('created_at', descending: true)
        .startAfterDocument(documentList.last)
        .limit(10)
        .snapshots();
    return notis;
  }

  Future<void> readNotification(String id) async {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('notification')
        .doc(id)
        .update({'read': true});
  }

  Future<void> enableLocation(Locationn locationn) async {
    return locationRef
        .doc(_firebaseAuth.currentUser.uid)
        .set(locationn.toJson());
  }

  Future<void> disableLocation() async {
    return locationRef.doc(_firebaseAuth.currentUser.uid).delete();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getLocation() async {
    return locationRef.snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getHealth() async {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('health_book')
        .orderBy('created_at', descending: true)
        .limit(10)
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getNextHealth(
      List documentList) async {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('health_book')
        .orderBy('created_at', descending: true)
        .startAfterDocument(documentList.last)
        .limit(10)
        .snapshots();
  }

  Future<void> fillHealth(
      HealthBook healthBook, String id, bool isUpdate) async {
    final health = usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .collection('health_book')
        .doc(id);
    return isUpdate
        ? health.update(healthBook.toJson())
        : health.set(healthBook.toJson());
  }
}
