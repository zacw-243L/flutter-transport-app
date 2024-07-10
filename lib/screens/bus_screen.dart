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
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _allBusStops = await ApiCalls().fetchBusStops();
    });
    super.initState(); // TODO: implement initState
  }

  Future<void> fetchBusStops() async {
    try {
      List<BusStop> busStops = await ApiCalls().fetchBusStops();
      setState(() {
        _allBusStops = busStops;
      });
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchBusArrivals(String busStopCode, String serviceNo) async {
    try {
      List<BusArrival> busArrivals =
          await ApiCalls().fetchBusArrivals(busStopCode, serviceNo);
      setState(() {
        _busArrivals = busArrivals;
      });
    } catch (error) {
      throw (error);
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
    DateTime parsedDateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(parsedDateTime);
    int minutes = difference.inMinutes * -1;
    if (minutes <= 0) {
      return 'Departed';
    } else if (minutes == 0 || minutes == 1) {
      return 'Arrived';
    }
    return 'Arriving in $minutes min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5E60CE).withOpacity(0.85),
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
              ShowMap(selectedBusStop: _selectedBusStop),
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

class ShowMap extends StatelessWidget {
  const ShowMap({
    super.key,
    required BusStop selectedBusStop,
  }) : _selectedBusStop = selectedBusStop;

  final BusStop _selectedBusStop;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
