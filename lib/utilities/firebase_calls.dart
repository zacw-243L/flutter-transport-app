import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bus_arrival.dart';
import '../models/bus_stop.dart';
import '../models/taxi_fare.dart';

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference faresCollection =
    FirebaseFirestore.instance.collection('fares');

class FirebaseCalls {
  void addTaxiFare() {
    //TODO Add taxi fare to fares collection
  }
}
