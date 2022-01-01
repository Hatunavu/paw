import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HealthBook {
  final String id;
  final DateTime createdAt;
  final DateTime schedule;
  final String title;
  final bool done;
  final String address;
  HealthBook(
      {@required this.id,
      @required this.title,
      @required this.createdAt,
      @required this.schedule,
      @required this.address,
      @required this.done});

  factory HealthBook.fromDoc(DocumentSnapshot doc) {
    return HealthBook(
        id: doc['id'],
        title: doc['title'],
        createdAt: doc['created_at'].toDate(),
        schedule: doc['schedule'].toDate(),
        address: doc['address'],
        done: doc['done']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'created_at': createdAt,
        'schedule': schedule,
        'address': address,
        'done': done
      };
}
