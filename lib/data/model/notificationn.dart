import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:flutter/cupertino.dart';

class Notificationn {
  final String notiId;
  final String type;
  final bool read;
  final DateTime createdAt;
  final BaseUser userPush;
  final BaseUser userPull;
  final String image;
  final String postId;
  final String comment;
  final String caption;
  final DateTime createdPost;
  Notificationn(
      {@required this.notiId,
      @required this.type,
      @required this.read,
      @required this.createdAt,
      @required this.userPush,
      @required this.userPull,
      @required this.image,
      @required this.postId,
      @required this.comment,
      @required this.caption,
      @required this.createdPost});

  factory Notificationn.fromJson(QueryDocumentSnapshot json) {
    return Notificationn(
      notiId: json['noti_id'],
      type: json['type'],
      read: json['read'],
      createdAt: json['created_at'].toDate(),
      createdPost: json['created_post'].toDate() ?? DateTime.now(),
      userPush: BaseUser.fromJson(json['user_noti']),
      userPull: BaseUser.fromJson(json['userrp']),
      image: json['image'],
      postId: json['post_id'],
      comment: json['comment'],
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() => {
        'noti_id': notiId,
        'type': type,
        'read': read,
        'created_at': createdAt,
        'user_noti': userPush.toJson(),
        'userrp': userPull.toJson(),
        'image': image,
        'post_id': postId,
        'comment': comment,
        'caption': caption,
        'created_post': createdPost
      };
}
