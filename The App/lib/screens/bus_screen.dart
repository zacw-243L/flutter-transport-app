import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utilities/api_calls.dart';
import '../utilities/constants.dart';
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
  int skip = 0;
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
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _setRandomGreeting();
    Future.delayed(Duration.zero, () async {
      _allBusStops = await ApiCalls().fetchBusStops(skip);
    });
  }

  void _setRandomGreeting() {
    final greetings = [
      'Hello',
      'Welcome',
      'Greetings',
      'Hey',
    ];
    final random = Random();
    _greeting = greetings[random.nextInt(greetings.length)];
  }

  Future<void> fetchBusStops() async {
    try {
      List<BusStop> busStops = await ApiCalls().fetchBusStops(skip);
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
    } else if (minutes <= 1) {
      return 'Arrived';
    }
    return 'ETA: $minutes min';
  }

  Future<void> _updateCategory(String category) async {
    setState(() {
      switch (category) {
        case 'Page 1':
          skip = 0;
          break;
        case 'Page 2':
          skip = 500;
          break;
        case 'Page 3':
          skip = 1000;
          break;
        case 'Page 4':
          skip = 1500;
          break;
        case 'Page 5':
          skip = 2000;
          break;
        case 'Page 6':
          skip = 2500;
          break;
        case 'Page 7':
          skip = 3000;
          break;
        case 'Page 8':
          skip = 3500;
          break;
        case 'Page 9':
          skip = 4000;
          break;
        case 'Page 10':
          skip = 4500;
          break;
        case 'Page 11':
          skip = 5000;
          break;
      }
    });
    await fetchBusStops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5E60CE).withOpacity(0.85),
        title: Text(
          "LionTransport".toUpperCase(),
          style: kAppName,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.swap_horiz_rounded,
              color: Colors.white,
            ),
            onSelected: _updateCategory,
            itemBuilder: (BuildContext context) {
              return {
                'Page 1',
                'Page 2',
                'Page 3',
                'Page 4',
                'Page 5',
                'Page 6',
                'Page 7',
                'Page 8',
                'Page 9',
                'Page 10',
                'Page 11',
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/bus.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Center(
                child: Text(
                  '$_greeting ${auth.currentUser?.displayName}',
                  style: kWelcomeUser,
                ),
              ),
              SizedBox(height: 15),
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
                    });
                    List<BusArrival> busArrivals = await ApiCalls()
                        .fetchBusArrivals(
                            _selectedBusStop.busStopCode, _selectedServiceNo);
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
                      style: kInfo, // Change the text color to white
                      decoration: InputDecoration(
                        hintText: 'Enter bus stop',
                        hintStyle: kInfo,
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none, // No border side
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _busArrivals.length,
                  itemBuilder: (context, index) {
                    BusArrival busArrival = _busArrivals[index];
                    return BusArrivalTile(
                        busArrival: busArrival,
                        BusType: BusType,
                        arriveTime: arriveTime,
                        image: Image.asset('${BusType}.png'));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ShowMap(selectedBusStop: _selectedBusStop),
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
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.50,
      child: ElevatedButton(
        onPressed: () async {
          if (_selectedBusStop.latitude != 0 &&
              _selectedBusStop.longitude != 0) {
            try {
              await openMap(
                _selectedBusStop.latitude,
                _selectedBusStop.longitude,
              );
            } catch (e) {
              throw ('Error opening map: $e');
            }
          } else {
            throw ('Invalid coordinates: ${_selectedBusStop.latitude}, ${_selectedBusStop.longitude}');
          }
        },
        child: Row(
          children: [
            const Text('Show Map', style: kShowMap),
            SizedBox(
              width: screenSize.width * 0.03,
            ),
            Icon(Icons.location_on)
          ],
        ),
      ),
    );
  }
}

class BusArrivalTile extends StatelessWidget {
  final BusArrival busArrival;
  final String Function(BusArrival) BusType;
  final String Function(String) arriveTime;
  final Image image;

  BusArrivalTile({
    required this.busArrival,
    required this.BusType,
    required this.arriveTime,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    String arrivalInfo = arriveTime(busArrival.nextBus.estimatedArrival);
    Color arrivalColor;

    if (arrivalInfo == 'Arrived')
      arrivalColor = Colors.green;
    else if (arrivalInfo == 'Departed')
      arrivalColor = Colors.red;
    else
      arrivalColor = kbiggertimer.color ?? Colors.white;

    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Transform.translate(
                offset: Offset(10.0, 30.0),
                child: buildInfoCard(),
              ),
              Transform.translate(
                offset: Offset(170.0, 30.0),
                child: Card(
                  color: Color(0xFF5E60CE).withOpacity(0.80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text('Bus No: ${busArrival.serviceNo}',
                                style: kBusTitle),
                            Text(
                              arrivalInfo,
                              style: kbiggertimer.copyWith(color: arrivalColor),
                            ),
                            Container(
                              height: 55,
                              child: loadImageWithGradient(
                                "images/${BusType(busArrival)}.png",
                                busArrival.nextBus.load,
                              ),
                            ),
                            Text(
                              busArrival.nextBus.feature == "WAB"
                                  ? "Wheelchair Accessible"
                                  : "Wheelchair Inaccessible",
                              style: kAccessible,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget loadImageWithGradient(String imagePath, String load) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return getGradient(load).createShader(rect);
      },
      child: Image.asset(
        imagePath,
        color: Colors.white,
        fit: BoxFit.cover,
      ),
    );
  }

  LinearGradient getGradient(String load) {
    switch (load.toUpperCase()) {
      case 'LSD':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1, 1],
          colors: [Colors.red, Colors.red, Colors.red],
        );
      case 'SEA':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [3 / 5, 3 / 9, 1],
          colors: [Colors.white, Colors.green, Color(0xFF008000)],
        );
      case 'SDA':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [3 / 8, 3 / 9, 1],
          colors: [Colors.white, Colors.orange, Colors.orange],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1, 1],
          colors: [Colors.white, Colors.white, Colors.grey],
        );
    }
  }

  Widget buildInfoCard() {
    return Container(
      width: 550, // Example width
      height: 180, // Example height
      child: Card(
        color: Color(0xFF3E80CE).withOpacity(0.65),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 10, 40, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Next Buses",
                style: kInfo,
              ),
              if (busArrival.nextBus2 != null &&
                  busArrival.nextBus2!.estimatedArrival
                      .isNotEmpty) // Check if nextBus2 is not null and has an estimated arrival time
                buildRow(
                  Icons.directions_bus,
                  arriveTime(busArrival.nextBus2!.estimatedArrival),
                  busArrival.nextBus2!.load,
                ),
              if (busArrival.nextBus3 != null &&
                  busArrival.nextBus3!.estimatedArrival
                      .isNotEmpty) // Check if nextBus3 is not null and has an estimated arrival time
                buildRow(
                  Icons.directions_bus,
                  arriveTime(busArrival.nextBus3!.estimatedArrival),
                  busArrival.nextBus3!.load,
                ),
              if ((busArrival.nextBus2 == null ||
                      busArrival.nextBus2!.estimatedArrival.isEmpty) &&
                  (busArrival.nextBus3 == null ||
                      busArrival.nextBus3!.estimatedArrival
                          .isEmpty)) // Check if both nextBus2 and nextBus3 are null or have no estimated arrival time
                buildErrorRow("No buses"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String text, String load) {
    return Row(
      children: [
        loadIcon(load),
        SizedBox(width: 10),
        Text(
          text,
          style: ksmallerinfo,
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

Widget buildErrorRow(String errorMessage) {
  return Row(
    children: [
      Icon(Icons.error, color: Colors.red),
      SizedBox(width: 10),
      Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    ],
  );
}

Widget loadIcon(String load) {
  return Stack(
    children: [
      Icon(
        Icons.directions_bus,
        color: Colors.grey,
        size: 30,
      ),
      load.toUpperCase() == 'LSD'
          ? ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1, 1],
                  colors: [Colors.red, Colors.red, Colors.red],
                ).createShader(rect);
              },
              child: Icon(
                Icons.directions_bus,
                color: Colors.white, // shader colour
                size: 30,
              ),
            )
          : load.toUpperCase() == 'SEA'
              ? ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [3 / 5, 3 / 9, 1],
                      colors: [Colors.grey, Colors.green, Color(0xFF006400)],
                    ).createShader(rect);
                  },
                  child: Icon(
                    Icons.directions_bus,
                    color: Colors.white, // shader colour
                    size: 30,
                  ),
                )
              : load.toUpperCase() == 'SDA'
                  ? ShaderMask(
                      shaderCallback: (Rect rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [3 / 8, 3 / 9, 1],
                          colors: [Colors.grey, Colors.orange, Colors.orange],
                        ).createShader(rect);
                      },
                      child: Icon(
                        Icons.directions_bus,
                        color: Colors.white, // shader colour
                        size: 30,
                      ),
                    )
                  : ShaderMask(
                      shaderCallback: (Rect rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 1, 1],
                          colors: [Colors.grey, Colors.grey, Colors.grey],
                        ).createShader(rect);
                      },
                      child: Icon(
                        Icons.directions_bus,
                        color: Colors.white, // color of the shader
                        size: 30,
                      ),
                    ),
    ],
  );
}
