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
              // Implement logout functionality
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Hello ${auth.currentUser?.displayName}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          DropdownButton<BusStop>(
            hint: Text('Select Bus Stop'),
            value:
                _selectedBusStop.busStopCode.isEmpty ? null : _selectedBusStop,
            items: _allBusStops.map((busStop) {
              return DropdownMenuItem<BusStop>(
                value: busStop,
                child: Text(busStop.description),
              );
            }).toList(),
            onChanged: (busStop) {
              setState(() {
                _selectedBusStop = busStop!;
              });
            },
          ),
        ],
      ),
    );
  }
}
