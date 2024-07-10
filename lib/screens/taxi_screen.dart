import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';
import '../utilities/my_url_launcher.dart';

import '../models/taxi_stand.dart';
import '../widgets/navigation_bar.dart';
import 'add_taxi_screen.dart';

class TaxiScreen extends StatefulWidget {
  const TaxiScreen({super.key});

  @override
  State<TaxiScreen> createState() => _TaxiScreenState();
}

class _TaxiScreenState extends State<TaxiScreen> {
  List<TaxiStand> _alltaxiStands = [];

  TaxiStand _selectedTaxiStand = TaxiStand(
    latitude: 0,
    longitude: 0,
    name: '',
  );

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      _alltaxiStands = await ApiCalls().fetchTaxiStands();
    });

    super.initState();
  }

  Future<void> fetchTaxiStands() async {
    try {
      List<TaxiStand> taxistands = await ApiCalls().fetchTaxiStands();
      setState(() {
        _alltaxiStands = taxistands;
      });
    } catch (error) {
      print('Error fetching taxi stands $error');
      // Handle error (e.g., show error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Taxi'),
        ),
        bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Autocomplete<TaxiStand>(
                displayStringForOption: (TaxiStand option) => option.name,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<TaxiStand>.empty();
                  } else {
                    return _alltaxiStands.where((TaxiStand taxiStand) {
                      return taxiStand.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  }
                },
                onSelected: (TaxiStand selection) {
                  setState(() {
                    _selectedTaxiStand = selection;
                  });
                },
              ),
            ),
            SizedBox(height: 20), // Add a 20 pixel high empty space
            Center(
              child: SizedBox(
                width: 200, // Set the width of the button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: () async {
                    if (_selectedTaxiStand.latitude != 0 &&
                        _selectedTaxiStand.longitude != 0) {
                      try {
                        await openMap(
                          _selectedTaxiStand.latitude,
                          _selectedTaxiStand.longitude,
                        );
                      } catch (e) {
                        print('Error opening map: $e');
                        // Handle error (e.g., show error message)
                      }
                    } else {
                      print(
                          'Invalid coordinates: ${_selectedTaxiStand.latitude}, ${_selectedTaxiStand.longitude}');
                      // Handle invalid coordinates (e.g., show message to user)
                    }
                  },
                  child: const Text(
                    'Show Map',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add a 20 pixel high empty space
            Center(
              child: SizedBox(
                width: 200, // Set the width of the button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40)),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: const AddTaxiScreen(),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Add Taxi Fare',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
