import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:sgtransport/models/taxi_ava.dart';
import '../utilities/api_calls.dart';
import '../utilities/constants.dart';
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
  bool _isLoading = false;
  List<TaxiStand> _alltaxiStands = [];
  List<TaxiAVA> _allavataxis = [];
  TaxiStand _selectedTaxiStand = TaxiStand(latitude: 0, longitude: 0, name: '');
  TaxiAVA _selectedTaxilocation = TaxiAVA(
    latitude: 0,
    longitude: 0,
  );

  List<String> _loadingBlurbs = [
    "Finding a taxi...",
    "Checking for availability...",
    "Contacting driver",
    "Almost done..."
  ];
  int _currentBlurbIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchTaxiStands();
    fetchTaxiAVA();
  }

  Future<void> fetchTaxiStands() async {
    try {
      List<TaxiStand> taxistands = await ApiCalls().fetchTaxiStands();
      setState(() {
        _alltaxiStands = taxistands;
      });
    } catch (error) {
      throw ('Error fetching taxi stands: $error');
    }
  }

  Future<void> fetchTaxiAVA() async {
    try {
      List<TaxiAVA> taxiava = await ApiCalls().fetchTaxiAVA();
      setState(() {
        _allavataxis = taxiava;
      });
    } catch (error) {
      throw ('Error fetching taxi stands: $error');
    }
  }

  Future<void> _startLoading() async {
    setState(() {
      _isLoading = true;
      _currentBlurbIndex = 0;
    });

    for (int i = 0; i < _loadingBlurbs.length; i++) {
      setState(() {
        _currentBlurbIndex = i;
      });
      await Future.delayed(Duration(milliseconds: 1000));
    }

    await Future.delayed(Duration(milliseconds: 1000)); // simulate loading time

    if (_allavataxis.isNotEmpty) {
      final random = Random();
      _selectedTaxilocation = _allavataxis[random.nextInt(_allavataxis.length)];
      if (_selectedTaxilocation.latitude != 0 &&
          _selectedTaxilocation.longitude != 0) {
        try {
          await openMap(
            _selectedTaxilocation.latitude,
            _selectedTaxilocation.longitude,
          );
        } catch (e) {
          throw ('Error opening map: $e');
        }
      } else {
        throw ('Invalid coordinates: ${_selectedTaxilocation.latitude}, ${_selectedTaxilocation.longitude}');
      }
    } else {
      print('No available taxis');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseCalls firebaseCalls = FirebaseCalls();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5E60CE).withOpacity(0.85),
        title: Text(
          "LionTransport".toUpperCase(),
          style: kAppName,
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/taxikun.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),
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
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: kInfo, // user input text color
                      decoration: InputDecoration(
                        hintText: 'Enter taxi stand name', // hint text
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
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: firebaseCalls.getUserFaresStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Error: ', style: kShadow),
                          TextSpan(
                              text: '${snapshot.error}', style: kShadowRed2),
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Total spent to date: ', style: kShadow),
                          TextSpan(text: '-\$0.00', style: kShadowRed2),
                        ],
                      ),
                    );
                  }

                  double totalFare = snapshot.data!.docs.fold(0.0, (sum, doc) {
                    double fare = (doc['fare'] != null)
                        ? double.parse(doc['fare'].toString())
                        : 0.0;
                    return sum + fare;
                  });

                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Total spent to date: ', style: kShadow),
                        TextSpan(
                            text: '-\$${totalFare.toStringAsFixed(2)}',
                            style: kShadowRed2),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firebaseCalls.getUserFaresStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child:
                              Text('Error: ${snapshot.error}', style: kInfo));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text('No fares found', style: kInfo));
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          // Ensure the necessary fields are not null and handle the date formatting
                          String origin = data['origin'] ?? 'Unknown Origin';
                          String destination =
                              data['dest'] ?? 'Unknown Destination';
                          String fare =
                              data['fare']?.toString() ?? 'Unknown Fare';

                          // Handle Firestore Timestamp or String
                          Timestamp timestamp;
                          if (data['date'] is Timestamp) {
                            timestamp = data['date'];
                          } else if (data['date'] is String) {
                            timestamp = Timestamp.fromDate(
                                DateFormat('yyyy-MM-dd').parse(data['date']));
                          } else {
                            timestamp = Timestamp.now();
                          }

                          DateTime date = timestamp.toDate();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(date);

                          return ListTile(
                            title:
                                Text('$origin > $destination', style: kShadow),
                            subtitle: Text(formattedDate, style: kShadow2),
                            trailing: Text('-\$$fare', style: kShadowRed),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        await _startLoading();
                      },
                      child: _isLoading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            )
                          : Icon(Icons.search),
                      backgroundColor: Color(0xFFB500B5),
                      tooltip: 'Search for available taxi',
                    ),
                    SizedBox(
                      width: screenSize.width * 0.07,
                    ),
                    ShowMapButton(
                      selectedTaxiStand: _selectedTaxiStand,
                      openMap: openMap,
                    ),
                    SizedBox(width: screenSize.width * 0.07),
                    FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: const AddTaxiScreen(),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.add),
                      backgroundColor:
                          Color(0xFFFFFFFF), // Customize the background color
                      tooltip:
                          'Add Taxi Fare', // Optional tooltip for accessibility
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Center(
              child: Container(
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(13.0),
                ),
                child: Text(
                  _loadingBlurbs[_currentBlurbIndex],
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ShowMapButton extends StatelessWidget {
  final TaxiStand selectedTaxiStand;
  final Future<void> Function(double latitude, double longitude) openMap;

  ShowMapButton({
    required this.selectedTaxiStand,
    required this.openMap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 40),
        ),
        onPressed: () async {
          if (selectedTaxiStand.latitude != 0 &&
              selectedTaxiStand.longitude != 0) {
            try {
              await openMap(
                selectedTaxiStand.latitude,
                selectedTaxiStand.longitude,
              );
            } catch (e) {
              throw ('Error opening map: $e');
            }
          } else {
            throw ('Invalid coordinates: ${selectedTaxiStand.latitude}, ${selectedTaxiStand.longitude}');
          }
        },
        child: Row(
          children: [
            const Text(
              'Show Map',
              style: kShowMap,
            ),
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
