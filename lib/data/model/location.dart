import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/base_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class Locationn with ClusterItem {
  final double longitude;
  final double latitude;
  final BaseUser user;
  Locationn(
      {@required this.longitude, @required this.latitude, @required this.user});
  factory Locationn.fromDoc(DocumentSnapshot doc) {
    return Locationn(
        longitude: doc['longitude'],
        latitude: doc['latitude'],
        user: BaseUser.fromJson(doc['user']));
  }

  Map<String, dynamic> toJson() =>
      {'longitude': longitude, 'latitude': latitude, 'user': user.toJson()};

  @override
  LatLng get location => LatLng(latitude, longitude);
}
