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
  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('fares');

  final TextEditingController originController = TextEditingController();
  final TextEditingController destController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

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
            decoration: const InputDecoration(labelText: 'Date'),
            controller: dateController,
          ),
          SizedBox(height: 20), // Add some space before the button
          ElevatedButton(
            onPressed: () {}, // Empty onPressed callback
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
