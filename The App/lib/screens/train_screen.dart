import 'package:flutter/material.dart';
import '../utilities/api_calls.dart';
import '../models/train_stations_repository.dart';
import '../models/train_crowd_density.dart';
import '../utilities/constants.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';

String currentStation = "";
String currentLine = "";
String CrowdedInfo = "";
String StationCode = "";
List<String> lineCOD = [];

Color _getCrowdLevelColor(String crowdLevel) {
  switch (crowdLevel) {
    case 'Low':
      return Colors.green;
    case 'Moderate':
      return Colors.orange;
    case 'High':
      return Colors.red;
    default:
      return Colors.white; // Default color for 'Unknown' or 'No data available'
  }
}

Map<String, List<Station>> lineStations = {
  "CEL": generateLineStations(
      "CEL", currentStation, CELStationsList, CrowdedInfo, StationCode),
  "CGL": generateLineStations(
      "CGL", currentStation, CGLStationsList, CrowdedInfo, StationCode),
  "BPL": generateLineStations(
      "BPL", currentStation, BPLStationsList, CrowdedInfo, StationCode),
  "SLRT": generateLineStations(
      "SLRT", currentStation, SLRTStationsList, CrowdedInfo, StationCode),
  "PLRT": generateLineStations(
      "PLRT", currentStation, PLRTStationsList, CrowdedInfo, StationCode),
  "NSL": generateLineStations(
      "NSL", currentStation, NSLStationsList, CrowdedInfo, StationCode),
  "EWL": generateLineStations(
      "EWL", currentStation, EWLStationsList, CrowdedInfo, StationCode),
  "CCL": generateLineStations(
      "CCL", currentStation, CCLStationsList, CrowdedInfo, StationCode),
  "NEL": generateLineStations(
      "NEL", currentStation, NELStationsList, CrowdedInfo, StationCode),
  "DTL": generateLineStations(
      "DTL", currentStation, DTLStationsList, CrowdedInfo, StationCode),
};

Map<String, Color> lineColors = {
  "NSL": Colors.red,
  "EWL": Colors.green,
  "CGL": Colors.green,
  "CCL": Colors.orange,
  "CEL": Colors.orange,
  "NEL": Colors.purple,
  "DTL": Colors.blue,
  "BPL": Colors.grey,
  "SLRT": Colors.grey,
  "PLRT": Colors.grey,
};

class TrainScreen extends StatefulWidget {
  late List<Station> stationsz;

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

List<Station> generateLineStations(String line, String currentStation,
    List<String> stationList, String CrowdedInfo, String StationCode) {
  int currentStationIndex = stationList.indexOf(currentStation);
  String prefixes = "";
  String lastChar = "";
  String prefix = "";
  bool FlipEW = false;

  if (StationCode.isNotEmpty) {
    prefixes = StationCode.replaceAll(
        RegExp(r'\d'), ''); // Extract the alphabetic part
    prefix = prefixes.substring(0, prefixes.length - 1);
    lastChar = prefixes.substring(prefixes.length - 1);
  }

  if (lastChar == 'W' &&
      (int.parse(StationCode.replaceAll(RegExp(r'\D'), '')) - 1) < 1) {
    prefix += "E";
    FlipEW = true;
  } else if (lastChar == 'E' &&
      (int.parse(StationCode.replaceAll(RegExp(r'\D'), '')) - 1) < 1) {
    prefix += "W";
    FlipEW = true;
  } else
    prefix += lastChar;

  List<Station> stationsz = [
    if (currentStation.isNotEmpty && ((currentStationIndex - 2) >= 0))
      Station(
        stationName: (currentStationIndex - 2 >= 0)
            ? stationList[currentStationIndex - 2]
            : "",
        isMainStation: false,
        stationInfo: "",
        stationIcon: (currentStationIndex - 2 >= 0) ? Icons.circle : null,
        stationCode: FlipEW
            ? "${prefix}1"
            : (currentStationIndex - 2 >= 0)
                ? "$prefix${(int.parse(StationCode.replaceAll(RegExp(r'\D'), '')) - 2)}"
                : "",
      ),
    if (currentStation.isNotEmpty && ((currentStationIndex - 1) >= 0))
      Station(
        stationName: (currentStationIndex - 1 >= 0)
            ? stationList[currentStationIndex - 1]
            : "",
        isMainStation: false,
        stationInfo: "",
        stationIcon: (currentStationIndex - 1 >= 0) ? Icons.circle : null,
        stationCode: FlipEW
            ? "Junction"
            : (currentStationIndex - 1 >= 0)
                ? "$prefix${(int.parse(StationCode.replaceAll(RegExp(r'\D'), '')) - 1)}"
                : "",
      ),
    if (currentStation.isNotEmpty)
      Station(
          stationName: currentStation,
          isMainStation: true,
          stationInfo: CrowdedInfo,
          stationIcon: Icons.train,
          stationCode: StationCode),
    if (currentStation.isNotEmpty &&
        ((currentStationIndex + 1) <= (stationList.length - 1)))
      Station(
        stationName: (currentStationIndex + 1 <= stationList.length)
            ? stationList[currentStationIndex + 1]
            : "",
        isMainStation: false,
        stationInfo: "",
        stationIcon: (currentStationIndex + 1 < stationList.length)
            ? Icons.circle
            : null,
        stationCode: (currentStationIndex + 1 < stationList.length)
            ? "$prefixes${(int.parse(StationCode.replaceAll(RegExp(r'\D'), '')) + 1)}"
            : "",
      ),
    if (currentStation.isNotEmpty &&
        ((currentStationIndex + 2) <= (stationList.length - 1)))
      Station(
        stationName: (currentStationIndex + 2 <= stationList.length)
            ? stationList[currentStationIndex + 2]
            : "",
        isMainStation: false,
        stationInfo: "",
        stationIcon: (currentStationIndex + 2 < stationList.length)
            ? Icons.circle
            : null,
        stationCode: (currentStationIndex + 2 < stationList.length)
            ? "$prefixes${(int.parse(StationCode.replaceAll(RegExp(r'\D'), '')) + 2)}"
            : "",
      ),
  ];
  return stationsz;
}

class _TrainScreenState extends State<TrainScreen> {
  List<Station> stationsz = [];
  TrainStation _selectedTrainStation = TrainStation(
    stnCode: '',
    stnName: '',
    trainLine: '',
    trainLineCode: '',
  );

  late List<String> currentList;
  String currentCategory = 'NSL';

  List<CrowdDensity> _crowdDensities = [];
  final TrainStationsRepository _trainStationsRepository =
      TrainStationsRepository();
  List<TrainStation> _allTrainStations = [];

  @override
  void initState() {
    super.initState();
    currentList = NSLStationsList; // Initialize with fruits
    _allTrainStations = _trainStationsRepository.allTrainStations.toList();
    stationsz = lineStations[currentLine] ?? [];
    CrowdedInfo = _getCrowdLevelForStation();
  }

/*  void switchLine(String line, String currentStation) {
    if (lineStations.containsKey(line) &&
        lineStations[line]!
            .any((station) => station.stationName == currentStation)) {
      setState(() {
        currentLine = line;
        CrowdedInfo = _getCrowdLevelForStation();
      });
    } else {
      throw Exception('Station not found in the selected line');
    }
  }*/

  int find(String stationName) {
    int index = NSLStationsList.indexWhere((station) => station == stationName);
    if (index == -1) {
      index = EWLStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = CCLStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = NELStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = DTLStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = CELStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = CGLStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = BPLStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = SLRTStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = PLRTStationsList.indexWhere((station) => station == stationName);
    }
    return index;
  }

  Future<void> _fetchCrowdDensity() async {
    try {
      currentStation = _selectedTrainStation.stnName;
      currentLine = _selectedTrainStation.trainLineCode;
      List<CrowdDensity> crowdDensities = await ApiCalls()
          .fetchCrowdDensity(_selectedTrainStation.trainLineCode);
      setState(() {
        _crowdDensities = crowdDensities;
      });
    } catch (error) {
      throw ('Error fetching crowd density: $error');
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
    return '';
  }

  void _updateList(String value) {
    setState(() {
      switch (currentCategory) {
        case 'CEL':
          currentList = CELStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'CGL':
          currentList = CGLStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'BPL':
          currentList = BPLStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'SLRT':
          currentList = SLRTStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'PLRT':
          currentList = PLRTStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'NSL':
          currentList = NSLStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'EWL':
          currentList = EWLStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'CCL':
          currentList = CCLStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'NEL':
          currentList = NELStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
        case 'DTL':
          currentList = DTLStationsList.where((station) =>
              station.toLowerCase().contains(value.toLowerCase())).toList();
          break;
      }
    });
  }

  void _updateCategory(String category) {
    setState(() {
      currentCategory = category;
      switch (category) {
        case 'CEL':
          currentList = CELStationsList;
          break;
        case 'CGL':
          currentList = CGLStationsList;
          break;
        case 'BPL':
          currentList = BPLStationsList;
          break;
        case 'SLRT':
          currentList = SLRTStationsList;
          break;
        case 'PLRT':
          currentList = PLRTStationsList;
          break;
        case 'NSL':
          currentList = NSLStationsList;
          break;
        case 'EWL':
          currentList = EWLStationsList;
          break;
        case 'CCL':
          currentList = CCLStationsList;
          break;
        case 'NEL':
          currentList = NELStationsList;
          break;
        case 'DTL':
          currentList = DTLStationsList;
          break;
      }
    });
  }

  TrainStation _getStationDetails(String stationName, String trainLineCode) {
    return _trainStationsRepository.allTrainStations.firstWhere(
        (station) =>
            station.stnName.toLowerCase() == stationName.toLowerCase() &&
            station.trainLineCode == trainLineCode,
        orElse: () => TrainStation(
              stnCode: '',
              stnName: '',
              trainLine: '',
              trainLineCode: '',
            ));
  }

  @override
  Widget build(BuildContext context) {
    CrowdedInfo = _getCrowdLevelForStation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E60CE).withOpacity(0.85),
        title: Text(
          "LionTransport".toUpperCase(),
          style: kAppName,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.swap_horiz),
            onSelected: _updateCategory,
            itemBuilder: (BuildContext context) {
              return {
                'NSL',
                'EWL',
                'CEL',
                'CGL',
                'CCL',
                'NEL',
                'DTL',
                'BPL',
                'SLRT',
                'PLRT',
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
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/trainkun.png'),
                fit: BoxFit.cover, // Use BoxFit.cover for best fit
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      _updateList(textEditingValue.text);
                      return currentList;
                    },
                    /*                   displayStringForOption: (TrainStation option) =>
                        option.stnName,*/
                    onSelected: (String station) async {
                      setState(() {
                        _selectedTrainStation =
                            _getStationDetails(station, currentCategory);
                        if (_selectedTrainStation.trainLineCode == 'NEL') {
                          lineCOD = NELStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'NSL') {
                          lineCOD = NSLStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'EWL') {
                          lineCOD = EWLStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'CCL') {
                          lineCOD = CCLStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'NEL') {
                          lineCOD = NELStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'CEL') {
                          lineCOD = CELStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'CGL') {
                          lineCOD = CGLStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'DTL') {
                          lineCOD = DTLStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'BPL') {
                          lineCOD = BPLStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'SLRT') {
                          lineCOD = SLRTStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'PLRT') {
                          lineCOD = PLRTStationsList;
                        }
                      });
                      await _fetchCrowdDensity();
                      CrowdedInfo = _getCrowdLevelForStation();
                      if (lineCOD.isNotEmpty) {
                        print("CrowdDSFA$CrowdedInfo");
                        stationsz = generateLineStations(
                            _selectedTrainStation.trainLineCode,
                            _selectedTrainStation.stnName,
                            lineCOD,
                            CrowdedInfo,
                            _selectedTrainStation.stnCode);
                      }
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
                          hintText: 'Enter train station',
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
                  child: Container(
                    height: 410,
                    child: TrainSchedule(
                        currentStationIndex:
                            find(_selectedTrainStation.stnName),
                        currentLine: currentLine,
                        stationsz: stationsz,
                        lineColors: lineColors,
                        stationCode: _selectedTrainStation.stnCode),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrainSchedule extends StatelessWidget {
  final List<Station> stationsz;
  final int currentStationIndex;
  final String currentLine;
  final String stationCode;
  final Map<String, Color> lineColors;

  TrainSchedule({
    required this.stationsz,
    required this.currentStationIndex,
    required this.currentLine,
    required this.stationCode,
    required this.lineColors,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stationsz.length,
      itemBuilder: (context, index) {
        return StationItem(
          stationCode: stationsz[index].stationCode,
          stationName: stationsz[index].stationName,
          isMainStation: index == currentStationIndex,
          lineColor: lineColors[currentLine]!,
          stationInfo: stationsz[index].stationInfo,
          stationIcon: stationsz[index].stationIcon,
        );
      },
    );
  }
}

class Station {
  final String stationName;
  final bool isMainStation;
  final String stationInfo;
  final IconData? stationIcon; // Change to IconData type
  final String stationCode;

  Station(
      {required this.stationName,
      required this.isMainStation,
      required this.stationInfo,
      this.stationIcon, // Change to IconData type
      required this.stationCode});
}

class StationItem extends StatelessWidget {
  final String stationCode;
  final String stationName;
  final String stationInfo;
  final bool isMainStation;
  final IconData? stationIcon; // Change to IconData type
  final Color lineColor;

  StationItem({
    required this.stationCode,
    required this.stationName,
    required this.stationInfo,
    required this.isMainStation,
    this.stationIcon, // Change to IconData type
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Row(
        children: [
          _buildTimeline(context),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stationName, style: ktrainInfo),
                  Text(
                    stationCode,
                    style: ksmallertraininfo,
                  ),
                  if (stationInfo.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Crowd Level: ",
                            style: TextStyle(
                              fontSize:
                                  20.0, // Set font size for "Crowd Level: "
                              color: Colors.white, // Color for "Crowd Level: "
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                          TextSpan(
                            text: "$stationInfo",
                            style: TextStyle(
                              fontSize: 20.0, // Set font size for $stationInfo
                              color: _getCrowdLevelColor(
                                  stationInfo), // Color for $stationInfo
                              fontWeight:
                                  FontWeight.bold, // Bold for $stationInfo
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: 60,
      child: Column(
        children: [
          if (stationIcon != null)
            Container(
              width: 3,
              height: screenSize.height * 0.055,
              color: lineColor,
            ),
          if (stationIcon != null)
            Icon(stationIcon, color: lineColor, size: 24),
          if (stationIcon != null)
            Container(
              width: 3,
              height: screenSize.height * 0.055,
              color: lineColor,
            ),
        ],
      ),
    );
  }
}
