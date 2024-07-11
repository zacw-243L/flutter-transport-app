import 'package:flutter/material.dart';

import '../utilities/api_calls.dart';

import '../models/train_stations_repository.dart';
import '../models/train_crowd_density.dart';
import '../utilities/constants.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';

String currentStation = "Yew Tee"; //_selectedTrainStation.stnName
String currentLine = "NSL"; // Default line
String CrowdedInfo = "Moderate";

List<String> NSLStationsList = [
  "Jurong East",
  "Bukit Batok",
  "Bukit Gombak",
  "Choa Chu Kang",
  "Yew Tee",
  "Kranji",
  "Marsiling",
  "Woodlands",
  "Admiralty",
  "Sembawang",
  "Canberra",
  "Yishun",
  "Khatib",
  "Yio Chu Kang",
  "Ang Mo Kio",
  "Bishan",
  "Braddell",
  "Toa Payoh",
  "Novena",
  "Newton",
  "Orchard",
  "Somerset",
  "Dhoby Ghaut",
  "City Hall",
  "Raffles Place",
  "Marina Bay",
  "Marina South Pier",
];
List<String> EWLStationsList = [
  "Pasir Ris",
  "Tampines",
  "Simei",
  "Tanah Merah",
  "Bedok",
  "Kembangan",
  "Eunos",
  "Paya Lebar",
  "Aljunied",
  "Kallang",
  "Lavender",
  "Bugis",
  "City Hall",
  "Raffles Place",
  "Tanjong Pagar",
  "Outram Park",
  "Tiong Bahru",
  "Redhill",
  "Queenstown",
  "Commonwealth",
  "Buona Vista",
  "Dover",
  "Clementi",
  "Jurong East",
  "Chinese Garden",
  "Lakeside",
  "Boon Lay",
  "Pioneer",
  "Joo Koon",
  "Gul Circle",
  "Tuas Crescent",
  "Tuas West Road",
  "Tuas Link",
];
List<String> CCLStationsList = [
  "Dhoby Ghaut",
  "Bras Basah",
  "Esplanade",
  "Promenade",
  "Nicoll Highway",
  "Stadium",
  "Mountbatten",
  "Dakota",
  "Paya Lebar",
  "MacPherson",
  "Tai Seng",
  "Bartley",
  "Serangoon",
  "Lorong Chuan",
  "Bishan",
  "Marymount",
  "Caldecott",
  "Botanic Gardens",
  "Farrer Road",
  "Holland Village",
  "Buona Vista",
  "one-north",
  "Kent Ridge",
  "Haw Par Villa",
  "Pasir Panjang",
  "Labrador Park",
  "Telok Blangah",
  "HarbourFront",
];
List<String> NELStationsList = [
  "HarbourFront",
  "Outram Park",
  "Chinatown",
  "Clarke Quay",
  "Dhoby Ghaut",
  "Little India",
  "Farrer Park",
  "Boon Keng",
  "Potong Pasir",
  "Woodleigh",
  "Serangoon",
  "Kovan",
  "Hougang",
  "Buangkok",
  "Sengkang",
  "Punggol",
];
List<String> DTLStationsList = [
  "Bukit Panjang",
  "Cashew",
  "Hillview",
  "Beauty World",
  "King Albert Park",
  "Sixth Avenue",
  "Tan Kah Kee",
  "Botanic Gardens",
  "Stevens",
  "Newton",
  "Little India",
  "Rochor",
  "Bugis",
  "Promenade",
  "Bayfront",
  "Downtown",
  "Telok Ayer",
  "Chinatown",
  "Fort Canning",
  "Bencoolen",
  "Jalan Besar",
  "Bendemeer",
  "Geylang Bahru",
  "Mattar",
  "MacPherson",
  "Ubi",
  "Kaki Bukit",
  "Bedok North",
  "Bedok Reservoir",
  "Tampines West",
  "Tampines East",
  "Upper Changi",
];

Map<String, List<Station>> lineStations = {
  "NSL": generateLineStations("NSL", NSLStationsList),
  "EWL": generateLineStations("EWL", EWLStationsList),
  "CCL": generateLineStations("CCL", CCLStationsList),
  "NEL": generateLineStations("NEL", NELStationsList),
  "DTL": generateLineStations("DTL", DTLStationsList),
};

List<Station> generateLineStations(String line, List<String> stationList) {
  int currentStationIndex = stationList.indexOf(currentStation);
  List<Station> stationsz = [
    Station(
      stationName: (currentStationIndex - 2 >= 0)
          ? stationList[currentStationIndex - 2]
          : "",
      stationInfo: "",
      stationIcon: (currentStationIndex - 2 >= 0) ? Icons.circle : null,
    ),
    Station(
      stationName: (currentStationIndex - 1 >= 0)
          ? stationList[currentStationIndex - 1]
          : "",
      stationInfo: "",
      stationIcon: (currentStationIndex - 1 >= 0) ? Icons.circle : null,
    ),
    Station(
      stationName: currentStation,
      isMainStation: true,
      stationInfo: CrowdedInfo,
      stationIcon: Icons.train,
    ),
    Station(
      stationName: (currentStationIndex + 1 < stationList.length)
          ? stationList[currentStationIndex + 1]
          : "",
      stationInfo: "",
      stationIcon:
          (currentStationIndex + 1 < stationList.length) ? Icons.circle : null,
    ),
    Station(
      stationName: (currentStationIndex + 2 < stationList.length)
          ? stationList[currentStationIndex + 2]
          : "",
      stationInfo: "",
      stationIcon:
          (currentStationIndex + 2 < stationList.length) ? Icons.circle : null,
    ),
  ];
  return stationsz;
}

Map<String, Color> lineColors = {
  "NSL": Colors.red,
  "EWL": Colors.green,
  "CCL": Colors.orange,
  "NEL": Colors.purple,
  "DTL": Colors.blue,
};

class TrainScreen extends StatefulWidget {
  late List<Station> stationsz;

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  List<Station> stationsz = []; // Initialize the stationsz list
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
    stationsz = lineStations[currentLine] ?? [];
  }

  void switchLine(String line) {
    setState(() {
      currentLine = line;
      stationsz = lineStations[currentLine] ?? [];
    });
  }

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
    return '';
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

  Color _getTrainLineColor(String trainLineCode) {
    switch (trainLineCode) {
      case 'EWL':
        return Colors.green;
      case 'CCL':
        return Colors.orange;
      case 'NSL':
        return Colors.red;
      case 'NEL':
        return Colors.purple;
      case 'DTL':
        return Colors.blue;
      default:
        return Colors.white; // Default color if train line code doesn't match
    }
  }

  @override
  Widget build(BuildContext context) {
    String crowdLevel = _getCrowdLevelForStation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5E60CE).withOpacity(0.85),
        title: Text(
          "LionTransport".toUpperCase(),
          style: kAppName,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: switchLine,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'NSL',
                child: Text('NSL'),
              ),
              PopupMenuItem<String>(
                value: 'EWL',
                child: Text('EWL'),
              ),
              PopupMenuItem<String>(
                value: 'CCL',
                child: Text('CCL'),
              ),
              PopupMenuItem<String>(
                value: 'NEL',
                child: Text('NEL'),
              ),
              PopupMenuItem<String>(
                value: 'DTL',
                child: Text('DTL'),
              ),
              // Add more lines as needed
            ],
          ),
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black, // Set the color of the logout icon to black
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
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
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
                Container(
                  height: 410,
                  child: TrainSchedule(
                    currentStationIndex: find(currentStation),
                    currentLine: currentLine,
                    stationsz: stationsz,
                    lineColors: lineColors, // Pass lineColors here
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              // Container(
              //   margin: EdgeInsets.all(20),
              //   padding: EdgeInsets.all(
              //       30), // Add some padding to make the container bigger
              //   decoration: BoxDecoration(
              //     color: Colors.deepPurple.withOpacity(
              //         0.65), // 30% opacity deep purple background
              //     borderRadius: BorderRadius.all(
              //         Radius.circular(23)), // Round the corners
              //   ),
              //   child: Column(
              //     children: [
              //       RichText(
              //         text: TextSpan(
              //           text: 'Selected Station: ', // Bold the text
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 22,
              //             shadows: [
              //               Shadow(
              //                 offset: Offset(2.0, 2.0),
              //                 blurRadius: 3.0,
              //                 color: Color.fromARGB(255, 0, 0, 0),
              //               ),
              //             ],
              //           ),
              //           children: <TextSpan>[
              //             TextSpan(
              //               text: _selectedTrainStation.stnName,
              //               style: TextStyle(
              //                 color: Colors.white70,
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //                 shadows: [
              //                   Shadow(
              //                     offset: Offset(2.0, 2.0),
              //                     blurRadius: 3.0,
              //                     color: Color.fromARGB(255, 0, 0, 0),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(height: 20),
              //       RichText(
              //         text: TextSpan(
              //           text: 'Station Code: ', // Bold the text
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 22,
              //             shadows: [
              //               Shadow(
              //                 offset: Offset(2.0, 2.0),
              //                 blurRadius: 3.0,
              //                 color: Color.fromARGB(255, 0, 0, 0),
              //               ),
              //             ],
              //           ),
              //           children: <TextSpan>[
              //             TextSpan(
              //               text: _selectedTrainStation.stnCode,
              //               style: TextStyle(
              //                 color: _getTrainLineColor(
              //                     _selectedTrainStation.trainLineCode),
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //                 shadows: [
              //                   Shadow(
              //                     offset: Offset(2.0, 2.0),
              //                     blurRadius: 3.0,
              //                     color: Color.fromARGB(255, 0, 0, 0),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(height: 20),
              //       RichText(
              //         text: TextSpan(
              //           text: 'Crowd Level: ', // Bold the text
              //           style: TextStyle(
              //             fontSize: 22,
              //             color: Colors.white,
              //             shadows: [
              //               Shadow(
              //                 offset: Offset(2.0, 2.0),
              //                 blurRadius: 3.0,
              //                 color: Color.fromARGB(255, 0, 0, 0),
              //               ),
              //             ],
              //           ),
              //           children: [
              //             TextSpan(
              //               text: crowdLevel,
              //               style: TextStyle(
              //                 color: _getCrowdLevelColor(crowdLevel),
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //                 shadows: [
              //                   Shadow(
              //                     offset: Offset(2.0, 2.0),
              //                     blurRadius: 3.0,
              //                     color: Color.fromARGB(255, 0, 0, 0),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          Stack(
            children: [],
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
  final Map<String, Color> lineColors;

  TrainSchedule({
    required this.stationsz,
    required this.currentStationIndex,
    required this.currentLine,
    required this.lineColors, // Include lineColors as a required parameter
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stationsz.length,
      itemBuilder: (context, index) {
        return StationItem(
          stationName: stationsz[index].stationName,
          isMainStation: index == currentStationIndex,
          lineColor: lineColors[currentLine]!, // Access line color from the map
          stationInfo: stationsz[index].stationInfo,
          stationIcon: stationsz[index].stationIcon, // Pass stationIcon here
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

  Station({
    required this.stationName,
    this.isMainStation = false,
    required this.stationInfo,
    this.stationIcon, // Change to IconData type
  });
}

class StationItem extends StatelessWidget {
  final String stationName;
  final String stationInfo;
  final bool isMainStation;
  final IconData? stationIcon; // Change to IconData type
  final Color lineColor;

  StationItem({
    required this.stationName,
    required this.stationInfo,
    this.isMainStation = false,
    this.stationIcon, // Change to IconData type
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Row(
        children: [
          _buildTimeline(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(stationName, style: kInfo),
                  Text(stationInfo, style: kInfo),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      width: 50,
      child: Column(
        children: [
          if (stationIcon != null)
            Container(
              width: 2,
              height: 30,
              color: lineColor,
            ),
          if (stationIcon != null)
            Icon(stationIcon, color: lineColor, size: 24),
          if (stationIcon != null)
            Container(
              width: 2,
              height: 30,
              color: lineColor,
            ),
        ],
      ),
    );
  }
}
