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

/*  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      _selectedTrainStation = await ApiCalls().fetchCrowdDensity('trainLine');
    });

    super.initState();
  }*/

  List<CrowdDensity> _crowdDensities = [];
  final TrainStationsRepository _trainStationsRepository =
      TrainStationsRepository();
  List<TrainStation> _allTrainStations = [];

  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      _crowdDensities =
          await ApiCalls().fetchCrowdDensity(_selectedTrainStation.trainLine);
    });

    super.initState();
    _allTrainStations = _trainStationsRepository.allTrainStations.toList();
  }

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
            onSelected: (TrainStation station) {
              setState(() {
                _selectedTrainStation = station;
              });
            },
          ),
/*          Text('Selected Station: ${_selectedTrainStation.stnName}'),*/
        ],
      ),
    );
  }
}
