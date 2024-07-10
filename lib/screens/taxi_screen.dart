import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilities/api_calls.dart';
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
        title: const Text('Taxi'),
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
                ),
              ),
              SizedBox(height: 20), // Add a 20 pixel high empty space
              Center(
                child: ShowMapButton(
                  selectedTaxiStand: _selectedTaxiStand,
                  openMap: openMap,
                ),
              ),
              SizedBox(height: 20), // Add a 20 pixel high empty space
              Center(
                child: AddTaxiFareButton(),
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
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No fares found'));
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(
                              '${data['origin']} > ${data['destination']}'),
                          subtitle: Text('${data['date']}'),
                          trailing: Text('\$${data['fare']}'),
                        );
                      }).toList(),
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
      width: 200, // Set the width of the button
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
        child: const Text(
          'Show Map',
          style: TextStyle(fontSize: 20),
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
