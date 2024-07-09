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
    trainLine: 'EWL',
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

  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      _crowdDensities =
          await ApiCalls().fetchCrowdDensity(_selectedTrainStation.trainLine);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train'),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
    );
  }
}
