import 'package:flutter/material.dart';

import '../models/taxi_fare.dart';
import '../utilities/firebase_calls.dart';

class AddTaxiScreen extends StatefulWidget {
  const AddTaxiScreen({Key? key}) : super(key: key);

  @override
  State<AddTaxiScreen> createState() => _AddTaxiScreenState();
}

class _AddTaxiScreenState extends State<AddTaxiScreen> {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(labelText: 'Origin'),
          controller: originController,
        ),
      ],
    );
  }
}
