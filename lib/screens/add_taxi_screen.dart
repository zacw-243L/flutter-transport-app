import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/taxi_fare.dart';
import '../utilities/firebase_calls.dart';

class AddTaxiScreen extends StatefulWidget {
  const AddTaxiScreen({Key? key}) : super(key: key);

  @override
  State<AddTaxiScreen> createState() => _AddTaxiScreenState();
}

class _AddTaxiScreenState extends State<AddTaxiScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference faresCollection =
      FirebaseFirestore.instance.collection('fares');

  final TextEditingController originController = TextEditingController();
  final TextEditingController destController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> _addfares(
      String newOrigin, String newDest, double fare, DateTime date) {
    return faresCollection
        .add({
          'origin': newOrigin,
          'dest': newDest,
          'fare': fare,
          'date': date,
          'userid':
              auth.currentUser?.uid ?? '', // Ensure non-null value for userid
        })
        .then((value) => print("Taxi fare added"))
        .catchError((error) => print("Failed to add taxi fare: $error"));
  }

  void _handleAdd() {
    String origin = originController.text;
    String dest = destController.text;
    double fare = double.tryParse(fareController.text) ?? 0.0;
    DateTime date = DateTime.tryParse(dateController.text) ?? DateTime.now();

    _addfares(origin, dest, fare, date).then((_) {
      // Clear the text fields after successful addition
      originController.clear();
      destController.clear();
      fareController.clear();
      dateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Origin'),
            controller: originController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Destination'),
            controller: destController,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Fare'),
            controller: fareController,
            keyboardType: TextInputType.number,
          ),
          TextField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            controller: dateController,
          ),
          SizedBox(height: 20), // Add some space before the button
          ElevatedButton(
            onPressed: _handleAdd,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
