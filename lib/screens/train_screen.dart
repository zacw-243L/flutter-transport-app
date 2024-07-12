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
List<String> CELStationsList = [
  "Bayfront",
  "Marina Bay",
];
List<String> CGLStationsList = [
  "Expo",
  "Changi Airport",
];
List<String> BPLStationsList = [
  "Choa Chu Kang",
  "South View",
  "Keat Hong",
  "Teck Whye",
  "Phoenix",
  "Bukit Panjang",
  "Petir",
  "Pending",
  "Bangkit",
  "Fajar",
  "Segar",
  "Jelapang",
  "Senja",
];
List<String> SLRTStationsList = [
  "Sengkang",
  "Compassvale",
  "Rumbia",
  "Bakau",
  "Kangkar",
  "Ranggung",
];
List<String> SLRTBranchStationsList = [
  "Sengkang",
  "Cheng Lim",
  "Farmway",
  "Kupang",
  "Thanggam",
  "Fernvale",
  "Layar",
  "Tongkang",
  "Renjong",
];
List<String> PLRTStationsList = [
  "Punggol",
  "Cove",
  "Meridian",
  "Coral Edge",
  "Riviera",
  "Kadaloor",
  "Oasis",
  "Damai",
];
List<String> PLRTBranchStationsList = [
  "Punggol",
  "Sam Kee",
  "Punggol Point",
  "Samudera",
  "Nibong",
  "Sumang",
  "Soo Teck",
];
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
  "Marina Bay",
  "Bayfront",
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
  "Tampines",
  "Tampines East",
  "Upper Changi",
  "Expo",
];

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
  "CEL":
      generateLineStations("CEL", currentStation, CELStationsList, CrowdedInfo),
  "CGL":
      generateLineStations("CGL", currentStation, CGLStationsList, CrowdedInfo),
  "BPL":
      generateLineStations("BPL", currentStation, BPLStationsList, CrowdedInfo),
  "SLRT": generateLineStations(
      "SLRT", currentStation, SLRTStationsList, CrowdedInfo),
  "SLRTB": generateLineStations(
      "SLRTB", currentStation, SLRTBranchStationsList, CrowdedInfo),
  "PLRT": generateLineStations(
      "PLRT", currentStation, PLRTStationsList, CrowdedInfo),
  "PLRTB": generateLineStations(
      "PLRTB", currentStation, PLRTBranchStationsList, CrowdedInfo),
  "NSL":
      generateLineStations("NSL", currentStation, NSLStationsList, CrowdedInfo),
  "EWL":
      generateLineStations("EWL", currentStation, EWLStationsList, CrowdedInfo),
  "CCL":
      generateLineStations("CCL", currentStation, CCLStationsList, CrowdedInfo),
  "NEL":
      generateLineStations("NEL", currentStation, NELStationsList, CrowdedInfo),
  "DTL":
      generateLineStations("DTL", currentStation, DTLStationsList, CrowdedInfo),
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
  "BPLB": Colors.grey,
  "SLRT": Colors.grey,
  "SLRTB": Colors.grey,
  "PLRT": Colors.grey,
  "PLRTB": Colors.grey,
};

class TrainScreen extends StatefulWidget {
  late List<Station> stationsz;

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

List<Station> generateLineStations(String line, String currentStation,
    List<String> stationList, String CrowdedInfo) {
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
    if (currentStation.isNotEmpty)
      Station(
        stationName: currentStation,
        isMainStation: true,
        stationInfo: CrowdedInfo,
        stationIcon: Icons.train,
      ),
    if (currentStation.isNotEmpty)
      Station(
        stationName: (currentStationIndex + 1 <= stationList.length)
            ? stationList[currentStationIndex + 1]
            : "",
        stationInfo: "",
        stationIcon: (currentStationIndex + 1 < stationList.length)
            ? Icons.circle
            : null,
      ),
    if (currentStation.isNotEmpty)
      Station(
        stationName: (currentStationIndex + 2 <= stationList.length)
            ? stationList[currentStationIndex + 2]
            : "",
        stationInfo: "",
        stationIcon: (currentStationIndex + 2 < stationList.length)
            ? Icons.circle
            : null,
      ),
  ];
  return stationsz;
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
    CrowdedInfo = _getCrowdLevelForStation();
    _allTrainStations = _trainStationsRepository.allTrainStations.toList();
    stationsz = lineStations[currentLine] ?? [];
  }

  void switchLine(String line, String currentStation) {
    print("Running switchLine");
    if (lineStations.containsKey(line) &&
        lineStations[line]!
            .any((station) => station.stationName == currentStation)) {
      setState(() {
        currentLine = line;
      });
    } else {
      throw Exception('Station not found in the selected line');
    }
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
      index = SLRTBranchStationsList.indexWhere(
          (station) => station == stationName);
    }
    if (index == -1) {
      index = PLRTStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = PLRTBranchStationsList.indexWhere(
          (station) => station == stationName);
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

  @override
  Widget build(BuildContext context) {
    String CrowdedInfo = _getCrowdLevelForStation();
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
            onSelected: (String line) {
              switchLine(line,
                  currentStation); // Replace `currentStation` with your actual station variable
            },
            itemBuilder: (BuildContext context) {
              return {
                'NSL',
                'EWL',
                'EWLB',
                'CCL',
                'NEL',
                'DTL',
                'BPL',
                'BPLB',
                'SLRT',
                'SLRTB',
                'PLRT',
                'PLRTB'
              }.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
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
                      print("_allTrainStations");
                      print(_allTrainStations.where(
                          (station) => station.stnName.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              )));
                      return _allTrainStations.where(
                          (station) => station.stnName.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ));
                    },
                    displayStringForOption: (TrainStation option) =>
                        option.stnName,
                    onSelected: (TrainStation station) async {
                      setState(() {
                        List<String> lineCOD = [];
                        _selectedTrainStation = station;
                        CrowdedInfo = _getCrowdLevelForStation();
                        print("_selectedTrainStation.trainLineCode");
                        print(_selectedTrainStation.trainLineCode);
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
                            'SLRTB') {
                          lineCOD = SLRTBranchStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'PLRT') {
                          lineCOD = PLRTStationsList;
                        } else if (_selectedTrainStation.trainLineCode ==
                            'PLRTB') {
                          lineCOD = PLRTBranchStationsList;
                        }
                        if (lineCOD.isNotEmpty) {
                          stationsz = generateLineStations(
                            _selectedTrainStation.trainLineCode,
                            _selectedTrainStation.stnName,
                            lineCOD,
                            CrowdedInfo,
                          );
                        }
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
                        style: kInfo, // user input text color
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
                Text(
                  'Crowd Level: $CrowdedInfo',
                  style: TextStyle(
                      fontSize: 18, color: _getCrowdLevelColor(CrowdedInfo)),
                ),
                RichText(
                  text: TextSpan(
                      text: _selectedTrainStation.stnCode, style: kShadow),
                ),
                Expanded(
                  child: Container(
                    height: 410,
                    child: TrainSchedule(
                      currentStationIndex: find(_selectedTrainStation.stnName),
                      currentLine: currentLine,
                      stationsz: stationsz,
                      lineColors: lineColors, // Pass lineColors here
                    ),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stationName, style: kInfo),
                  Text("Crowd Level : $stationInfo",
                      style:
                          TextStyle(color: _getCrowdLevelColor(stationInfo))),
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
