import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  List<TaxiStand> _alltaxiStands = [];

  TaxiStand _selectedTaxiStand = TaxiStand(
    latitude: 0,
    longitude: 0,
    name: '',
  );

  @override
  void initState() {
    super.initState();
    fetchTaxiStands();
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
        backgroundColor: Color(0xFF5E60CE).withOpacity(0.85),
        title: Text(
          "LionTransport".toUpperCase(),
          style: kAppName,
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
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/taxikun.png', // Replace with your image asset path
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
                      style: TextStyle(
                          color: Colors.white), // user input text color
                      decoration: InputDecoration(
                        hintText: 'Enter taxi stand name', // hint text
                        hintStyle: kInfo,
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20), // Add a 20 pixel high empty space
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('fares')
                      .where('userid',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.white70)));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text('No fares found',
                              style: TextStyle(color: Colors.white60)));
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

                          // Handle Firestore Timestamp
                          Timestamp timestamp = data['date'] ?? Timestamp.now();
                          DateTime date = timestamp.toDate();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(date);

                          return ListTile(
                            title: Text(
                              '$origin > $destination',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20), // Bigger font size
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18), // Bigger font size
                            ),
                            trailing: Text(
                              '\$$fare',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18), // Bigger font size
                            ),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShowMapButton(
                      selectedTaxiStand: _selectedTaxiStand,
                      openMap: openMap,
                    ),
                    SizedBox(
                      width: 50,
                    ),
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
    return SizedBox(
      width: 180, // Set the width of the button
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
              print('Error opening map: $e');
              // Handle error (e.g., show error message)
            }
          } else {
            print(
                'Invalid coordinates: ${selectedTaxiStand.latitude}, ${selectedTaxiStand.longitude}');
            // Handle invalid coordinates (e.g., show message to user)
          }
        },
        child: Row(
          children: [
            const Text(
              'Show Map',
              style: TextStyle(fontSize: 20),
            ),
            Icon(Icons.location_on)
          ],
        ),
      ),
    );
  }
}

class AddTaxiFareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Set the width of the button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 40)),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
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
    );
  }
}
