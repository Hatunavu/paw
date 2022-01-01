import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:flutter/material.dart';

class BaseActivity extends BaseUser {
  final DateTime createdAt;
  BaseActivity(
      {@required uid,
      @required petName,
      @required avatar,
      @required this.createdAt})
      : super(uid: uid, petName: petName, avatar: avatar);

  factory BaseActivity.fromDoc(DocumentSnapshot doc) {
    return BaseActivity(
        uid: doc['uid'],
        petName: doc['pet_name'],
        avatar: doc['avatar'],
        createdAt: doc['created_at'].toDate());
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'pet_name': petName,
        'avatar': avatar,
        'created_at': createdAt
      };
}
