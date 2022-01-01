import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:flutter/cupertino.dart';

class Post extends UserPost {
  final BaseUser user;

  Post(
      {@required id,
      @required caption,
      @required location,
      @required image,
      @required createdAt,
      @required this.user})
      : super(
            id: id,
            caption: caption,
            location: location,
            image: image,
            createdAt: createdAt);

  factory Post.fromDoc(DocumentSnapshot doc) {
    print(doc['user']);
    return Post(
        id: doc['post_id'],
        caption: doc['caption'],
        location: doc['location'],
        image: doc['image'],
        createdAt: doc['created_at'].toDate(),
        user: BaseUser.fromJson(doc['user']));
  }

  Map<String, dynamic> toJson() => {
        'post_id': id,
        'caption': caption,
        'location': location,
        'image': image,
        'created_at': createdAt,
        'user': user.toJson()
      };
}
