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

  Future<void> _addFares(TaxiFare taxiFare) async {
    try {
      await faresCollection.add(taxiFare.toMap());

      // Clear the text fields after successful addition
      originController.clear();
      destController.clear();
      fareController.clear();
      dateController.clear();
    } catch (e) {
      throw ("Failed to add taxi fare: $e");
    }
  }

  void _handleAdd() {
    String origin = originController.text;
    String dest = destController.text;
    double fare;
    DateTime date;

    void showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: RichText(
              text: TextSpan(
                text: message,
                style: TextStyle(color: Colors.red),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    void showSuccessDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: RichText(
              text: TextSpan(
                text: message,
                style: TextStyle(color: Colors.green),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    if (origin.isEmpty ||
        dest.isEmpty ||
        fareController.text.isEmpty ||
        dateController.text.isEmpty) {
      showErrorDialog('Please fill in all fields');
      return;
    }

    if (origin.contains(RegExp(r'[0-9]')) || dest.contains(RegExp(r'[0-9]'))) {
      showErrorDialog('Origin and Destination should not contain numbers');
      return;
    }

    if (!fareController.text.contains(RegExp(r'^[0-9\.]+$'))) {
      showErrorDialog('Fare should only contain numbers');
      return;
    }

    fare = double.parse(fareController.text);

    String dateInput = dateController.text;
    if (!dateInput.contains(RegExp(r'^\d{4}-\d{2}-\d{2}$'))) {
      showErrorDialog(
          'Invalid input. Enter a valid date in YYYY-MM-DD format.');
      return;
    }

    List<String> dateParts = dateInput.split('-');
    if (dateParts.length != 3) {
      showErrorDialog(
          'Invalid input. Enter a valid date in YYYY-MM-DD format.');
      return;
    }

    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    if (!(1 <= month && month <= 12) || !(1 <= day && day <= 31)) {
      showErrorDialog('Invalid input. Invalid date.');
      return;
    }

    date = DateTime(year, month, day);

    // Convert the DateTime to a Timestamp
    Timestamp timestamp = Timestamp.fromDate(date);

    TaxiFare taxiFare = TaxiFare(
      origin: origin,
      dest: dest,
      fare: fare.toString(),
      date: timestamp, // Use the timestamp here
      userid: auth.currentUser?.uid ?? '', // Ensure non-null value for userid
    );
    // Add the taxiFare to your database or perform any other operation

    _addFares(taxiFare).then((_) {
      // Show success message
      showSuccessDialog('Taxi fare added successfully');
    }).catchError((e) {
      // Show error message
      showErrorDialog(e.toString());
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
