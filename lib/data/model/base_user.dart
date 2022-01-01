import 'package:flutter/material.dart';

class BaseUser {
  final String uid;
  final String petName;
  final String avatar;
  BaseUser({@required this.uid, @required this.avatar, @required this.petName});
  factory BaseUser.fromJson(Map<String, dynamic> json) {
    return BaseUser(
      uid: json['uid'],
      petName: json['pet_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'pet_name': petName, 'avatar': avatar};
}
