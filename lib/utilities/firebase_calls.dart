import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/taxi_fare.dart';

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference faresCollection =
    FirebaseFirestore.instance.collection('fares');

class FirebaseCalls {
  Future<void> addTaxiFare(TaxiFare taxiFare) async {
    try {
      await faresCollection.add(taxiFare.toMap());
    } catch (e) {
      throw ("Failed to add taxi fare: $e");
    }
  }

  Stream<QuerySnapshot> getUserFaresStream() {
    return faresCollection
        .where('userid', isEqualTo: auth.currentUser?.uid)
        .snapshots();
  }
}
