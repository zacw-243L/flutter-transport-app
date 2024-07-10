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
    double fare;
    DateTime date;

    if (origin.isEmpty ||
        dest.isEmpty ||
        fareController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (origin.contains(RegExp(r'[0-9]')) || dest.contains(RegExp(r'[0-9]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Origin and Destination should not contain numbers')),
      );
      return;
    }

    if (!fareController.text.contains(RegExp(r'^[0-9\.]+$'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fare should only contain numbers')),
      );
      return;
    }

    fare = double.parse(fareController.text);

    String dateInput = dateController.text;
    if (!dateInput.contains(RegExp(r'^\d{4}-\d{2}-\d{2}$'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Invalid input. Enter a valid date in YYYY-MM-DD format.')),
      );
      return;
    }

    List<String> dateParts = dateInput.split('-');
    if (dateParts.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Invalid input. Enter a valid date in YYYY-MM-DD format.')),
      );
      return;
    }

    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    if (!(1 <= month && month <= 12) || !(1 <= day && day <= 31)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid input. Invalid date.')),
      );
      return;
    }

    date = DateTime(year, month, day);

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
