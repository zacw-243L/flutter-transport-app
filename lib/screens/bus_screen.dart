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
  List<BusArrival> _busArrivals = [];
  BusStop _selectedBusStop = BusStop(
    busStopCode: '',
    roadName: '',
    description: '',
    latitude: 0,
    longitude: 0,
  );
  String _selectedServiceNo = '';
  String _busStopCode = '';

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

  Future<void> fetchBusArrivals(String busStopCode, String serviceNo) async {
    try {
      List<BusArrival> busArrivals =
          await ApiCalls().fetchBusArrivals(busStopCode, serviceNo);
      setState(() {
        _busArrivals = busArrivals;
      });
      print('Bus arrivals fetched: ${_busArrivals.length}');
    } catch (error) {
      print('Error fetching bus arrivals $error');
      // Handle error (e.g., show error message)
    }
  }

  Color getLoadColor(String load) {
    switch (load.toUpperCase()) {
      case 'LSD':
        return Colors.red;
      case 'SEA':
        return Colors.green;
      case 'SDA':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String BusType(BusArrival busArrival) {
    switch (busArrival.nextBus.type.toLowerCase()) {
      case 'dd':
        return 'Double decker';
      case 'sd':
        return 'Single decker';
      case 'bd':
        return 'Bendy Bus';
      default:
        return 'Unknown';
    }
  }

  String arriveTime(String dateTimeString) {
    // Parse the input datetime string into a DateTime object
    DateTime parsedDateTime = DateTime.parse(dateTimeString);

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the difference between now and the parsed datetime
    Duration difference = now.difference(parsedDateTime);

    // Convert the difference to minutes
    int minutes = difference.inMinutes;

    // Return the formatted string
    return 'Arriving in ${minutes * -1} min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x995E60CE).withOpacity(0.7),
        title: Text(
          "Bus lai liao".toUpperCase(),
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/bus.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Hello ${auth.currentUser?.displayName}',
                  style: TextStyle(fontSize: 27, color: Color(0xFFffffff)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Autocomplete<BusStop>(
                  displayStringForOption: (option) => option.description,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<BusStop>.empty();
                    } else {
                      return _allBusStops.where((busStop) {
                        return busStop.description.toLowerCase().contains(
                                textEditingValue.text.toLowerCase()) ||
                            busStop.roadName
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                      });
                    }
                  },
                  onSelected: (BusStop selection) async {
                    setState(() {
                      _selectedBusStop = selection;
                      print(
                          "Selected BusStop: ${_selectedBusStop!.description}"); // or print(_selectedBusStop.roadName)
                    });

                    List<BusArrival> busArrivals = await ApiCalls()
                        .fetchBusArrivals(
                            _selectedBusStop!.busStopCode, _selectedServiceNo);

                    setState(() {
                      _busArrivals = busArrivals;
                    });
                    print("Finish");
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: TextStyle(
                          color:
                              Colors.white), // Change the text color to white
                      decoration: InputDecoration(
                        hintText: 'Enter bus stop',
                        hintStyle: TextStyle(
                            color: Colors
                                .white), // Change the hint text color to white
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
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
                        }
                      } else {
                        print(
                            'Invalid coordinates: ${_selectedBusStop.latitude}, ${_selectedBusStop.longitude}');
                      }
                    },
                    child: const Text(
                      'Show Map',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _busArrivals.length,
                  itemBuilder: (context, index) {
                    BusArrival busArrival = _busArrivals[index];
                    return ListTile(
                      leading: Container(
                        width: 40, // Example width
                        height: 40, // Example height
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFFFF),
                        ),
                        child: Icon(
                          Icons.directions_bus,
                          color: getLoadColor(busArrival.nextBus.load),
                          size: 30,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Color(0xFF5E60CE).withOpacity(0.85),
                            child: Column(
                              children: [
                                Text('Bus No: ${busArrival.serviceNo}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                Text(
                                  arriveTime(
                                      busArrival.nextBus.estimatedArrival),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Center(
                                  child: Text(
                                    BusType(busArrival),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 30),
                                    Icon(
                                      Icons.accessible,
                                      color: busArrival.nextBus.feature == "WAB"
                                          ? Colors.green
                                          : Colors.red,
                                      size: 40,
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Adjust spacing between Icon and Text
                                    Text(
                                      busArrival.nextBus.feature == "WAB"
                                          ? "Wheelchair Accessible"
                                          : "Wheelchair Inaccessible",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Adjust text color as needed
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PopOutCard extends StatefulWidget {
  final Color color;
  final String arrivalTime;
  final List<String> buses;
  final String departureTime;
  final String wheelchair;
  final String eta;

  PopOutCard({
    required this.color,
    required this.arrivalTime,
    required this.buses,
    required this.departureTime,
    required this.wheelchair,
    required this.eta,
  });

  @override
  _PopOutCardState createState() => _PopOutCardState();
}

class _PopOutCardState extends State<PopOutCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              height: 140, // Specify the desired height
              width: 140, // Specify the desired width
              child: Card(
                //color: Colors.transparent,
                color: Color(0xFF5E60CE).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(children: [
                      Text(
                        widget.buses[0],
                        style: TextStyle(fontSize: 20, color: Colors.amber),
                      ),
                      Text(
                        widget.buses[1],
                        style: TextStyle(fontSize: 16, color: Colors.amber),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Very empty",
                        style: TextStyle(fontSize: 14, color: Colors.amber),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(120.0, 0.0), // Adjust the vertical offset as needed
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: widget.color,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bus_alert_outlined,
                            size: 30, color: Color(0xFFFFFFFF)),
                        Text('Arriving in: ${widget.arrivalTime}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Departure time: ${widget.departureTime}',
                        style: TextStyle(color: Colors.white.withOpacity(0.9))),
                    SizedBox(height: 8),
                    Text('Estimated arrival time: ${widget.eta}',
                        style: TextStyle(color: Colors.white.withOpacity(0.9))),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.wheelchair_pickup,
                            size: 30, color: Color(0xFFFFFFFF)),
                        Text('  Wheelchair accessible',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
