import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/base_activity.dart';
import 'package:flutter/material.dart';

class Comment extends BaseActivity {
  final String comment;
  Comment(
      {@required uid,
      @required avatar,
      @required petName,
      @required this.comment,
      @required createdAt})
      : super(uid: uid, avatar: avatar, petName: petName, createdAt: createdAt);

  factory Comment.fromDoc(DocumentSnapshot doc) {
    return Comment(
        uid: doc['uid'],
        avatar: doc['avatar'],
        petName: doc['pet_name'],
        comment: doc['comment'],
        createdAt: doc['created_at'].toDate());
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'avatar': avatar,
        'pet_name': petName,
        'comment': comment,
        'created_at': createdAt
      };
}
