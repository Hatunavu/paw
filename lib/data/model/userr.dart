import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:flutter/cupertino.dart';

class Userr extends BaseUser {
  final DateTime dateOfBirth;
  final int gender;
  final String species;
  final String favoriteFood;
  final String bossName;
  final int unreadNoti;
  final bool shareLocation;
  Userr(
      {@required uid,
      @required petName,
      @required this.dateOfBirth,
      @required this.gender,
      @required this.species,
      @required this.favoriteFood,
      @required this.bossName,
      @required avatar,
      @required this.unreadNoti,
      @required this.shareLocation})
      : super(uid: uid, avatar: avatar, petName: petName);

  factory Userr.fromDoc(DocumentSnapshot doc) {
    return Userr(
        uid: doc['uid'],
        petName: doc['pet_name'],
        dateOfBirth: doc['date_of_birth'].toDate(),
        gender: doc['gender'],
        species: doc['species'],
        favoriteFood: doc['favorite_food'],
        bossName: doc['boss_name'],
        avatar: doc['avatar'],
        unreadNoti: doc['unread_noti'],
        shareLocation: doc['share_location']);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'pet_name': petName,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'species': species,
        'favorite_food': favoriteFood,
        'boss_name': bossName,
        'avatar': avatar,
        'unread_noti': unreadNoti,
        'share_location': shareLocation
      };
}
