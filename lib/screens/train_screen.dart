import 'package:flutter/material.dart';

import '../utilities/api_calls.dart';

import '../models/train_stations_repository.dart';
import '../models/train_crowd_density.dart';
import '../utilities/constants.dart';
import '../widgets/navigation_bar.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  TrainStation _selectedTrainStation = TrainStation(
    stnCode: '',
    stnName: '',
    trainLine: '',
    trainLineCode: '',
  );

  List<CrowdDensity> _crowdDensities = [];
  final TrainStationsRepository _trainStationsRepository =
      TrainStationsRepository();
  List<TrainStation> _allTrainStations = [];

  @override
  void initState() {
    super.initState();
    _allTrainStations = _trainStationsRepository.allTrainStations.toList();
  }

  Future<void> _fetchCrowdDensity() async {
    try {
      List<CrowdDensity> crowdDensities = await ApiCalls()
          .fetchCrowdDensity(_selectedTrainStation.trainLineCode);
      setState(() {
        _crowdDensities = crowdDensities;
      });
    } catch (error) {
      print('Error fetching crowd density: $error');
      // Handle error (e.g., show error message)
    }
  }

  String _getCrowdLevelForStation() {
    for (var crowdDensity in _crowdDensities) {
      if (crowdDensity.station == _selectedTrainStation.stnCode) {
        switch (crowdDensity.crowdLevel) {
          case 'l':
            return 'Low';
          case 'm':
            return 'Moderate';
          case 'h':
            return 'High';
          default:
            return 'Unknown';
        }
      }
    }
    return 'No data available';
  }

  Color _getCrowdLevelColor(String crowdLevel) {
    switch (crowdLevel) {
      case 'Low':
        return Colors.green;
      case 'Moderate':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors
            .black; // Default color for 'Unknown' or 'No data available'
    }
  }

  @override
  Widget build(BuildContext context) {
    String crowdLevel = _getCrowdLevelForStation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train'),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/trainkun.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Autocomplete<TrainStation>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<TrainStation>.empty();
                    }
                    return _allTrainStations.where(
                        (station) => station.stnName.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            ));
                  },
                  displayStringForOption: (TrainStation option) =>
                      option.stnName,
                  onSelected: (TrainStation station) async {
                    setState(() {
                      _selectedTrainStation = station;
                    });
                    await _fetchCrowdDensity(); // Fetch crowd density after selecting a station
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
                        hintText: 'Enter train station', // hint text
                        hintStyle: kInfo,
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Selected Station: ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: _selectedTrainStation.stnName,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Station Code: ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: _selectedTrainStation.stnCode,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'Crowd Level: ',
                  style: TextStyle(
                      color: Colors.white), // Default text color for the prefix
                  children: [
                    TextSpan(
                      text: crowdLevel,
                      style: TextStyle(
                          color: _getCrowdLevelColor(
                              crowdLevel)), // Color based on crowd level
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
