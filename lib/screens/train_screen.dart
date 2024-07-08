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