import 'package:flutter/material.dart';

import '../utilities/api_calls.dart';

import '../models/train_stations_repository.dart';
import '../models/train_crowd_density.dart';
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

/*  String _getCrowdLevelForStation() {
    for (var crowdDensity in _crowdDensities) {
      if (crowdDensity.station == _selectedTrainStation.stnCode) {
        return crowdDensity.crowdLevel;
      }
    }
    return 'No data available';
  }*/
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

/*  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      _selectedTrainStation = await ApiCalls().fetchCrowdDensity('trainLine');
    });

    super.initState();
  }*/

/*  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      _crowdDensities =
          await ApiCalls().fetchCrowdDensity(_selectedTrainStation.trainLine);
    });

    super.initState();
    _allTrainStations = _trainStationsRepository.allTrainStations.toList();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train'),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: Column(
        children: [
          Autocomplete<TrainStation>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<TrainStation>.empty();
              }
              return _allTrainStations
                  .where((station) => station.stnName.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ));
            },
            displayStringForOption: (TrainStation option) => option.stnName,
            onSelected: (TrainStation station) async {
              setState(() {
                _selectedTrainStation = station;
              });
              await _fetchCrowdDensity(); // Fetch crowd density after selecting a station
            },
          ),
          SizedBox(height: 20),
          Text('Selected Station: ${_selectedTrainStation.stnName}'),
          SizedBox(height: 20),
          Text('Station Code: ${_selectedTrainStation.stnCode}'),
          SizedBox(height: 20),
          Text('Crowd Level: ${_getCrowdLevelForStation()}'),
        ],
      ),
    );
  }
}
