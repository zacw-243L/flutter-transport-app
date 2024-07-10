import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaxiFare {
  String origin;
  String dest;
  String fare;
  Timestamp date;
  String userid;

  TaxiFare({
    required this.origin,
    required this.dest,
    required this.fare,
    required this.date,
    required this.userid,
  });

  Map<String, dynamic> toMap() {
    return {
      'origin': origin,
      'dest': dest,
      'fare': fare,
      'date': date,
      'userid': userid,
    };
  }
}
