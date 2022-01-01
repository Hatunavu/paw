import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPost {
  final String id;
  final String caption;
  final String location;
  final String image;
  final DateTime createdAt;

  UserPost(
      {@required this.id,
      @required this.caption,
      @required this.location,
      @required this.image,
      @required this.createdAt});

  factory UserPost.fromDoc(DocumentSnapshot doc) {
    return UserPost(
        id: doc['id'],
        caption: doc['caption'],
        location: doc['location'],
        image: doc['image'],
        createdAt: doc['created_at'].toDate());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'caption': caption,
        'location': location,
        'image': image,
        'created_at': createdAt
      };
}
