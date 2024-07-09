import 'package:flutter/material.dart';

import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';
import '../utilities/my_url_launcher.dart';

import '../models/bus_arrival.dart';
import '../models/bus_stop.dart';
import '../widgets/navigation_bar.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  List<BusStop> _allBusStops = [];
  BusStop _selectedBusStop = BusStop(
    busStopCode: '',
    roadName: '',
    description: '',
    latitude: 0,
    longitude: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      _allBusStops = await ApiCalls().fetchBusStops();
    });

    super.initState();
  }

  Future<void> fetchBusStops() async {
    try {
      List<BusStop> busStops = await ApiCalls().fetchBusStops();
      setState(() {
        _allBusStops = busStops;
      });
    } catch (error) {
      print('Error fetching bus stops $error');
      // Handle error (e.g., show error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Arrival'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Hello ${auth.currentUser?.displayName}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Autocomplete<BusStop>(
            displayStringForOption: (option) => option.description,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<BusStop>.empty();
              } else {
                return _allBusStops.where((busStop) {
                  return busStop.description
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()) ||
                      busStop.roadName
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                });
              }
            },
            onSelected: (BusStop selection) {
              setState(() {
                _selectedBusStop = selection;
              });
            },
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
                  if (_selectedBusStop.latitude != 0 &&
                      _selectedBusStop.longitude != 0) {
                    try {
                      await openMap(
                        _selectedBusStop.latitude,
                        _selectedBusStop.longitude,
                      );
                    } catch (e) {
                      print('Error opening map: $e');
                      // Handle error (e.g., show error message to user)
                    }
                  } else {
                    print(
                        'Invalid coordinates: ${_selectedBusStop.latitude}, ${_selectedBusStop.longitude}');
                    // Handle invalid coordinates (e.g., show message to user)
                  }
                },
                child: const Text('Show Map'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
