import 'package:flutter/material.dart';
import '../utilities/api_calls.dart';
import '../models/train_stations_repository.dart';
import '../models/train_crowd_density.dart';
import '../utilities/constants.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';

String currentStation = ""; //_selectedTrainStation.stnName
String currentLine = "";
String CrowdedInfo = "";

List<String> EWLBranchStationsList = [
  "Tanah Merah",
  "Expo",
  "Changi Airport",
];
List<String> BPLBranchStationsList = [
  "Phoenix",
  "Ten Mile Junction",
  "Bukit Panjang",
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

Map<String, List<Station>> lineStations = {
  "EWLB": generateLineStations("EWLB", EWLBranchStationsList),
  "BPL": generateLineStations("BPL", BPLStationsList),
  "BPLB": generateLineStations("BPLB", BPLBranchStationsList),
  "SLRT": generateLineStations("SLRT", SLRTStationsList),
  "SLRTB": generateLineStations("SLRTB", SLRTBranchStationsList),
  "PLRT": generateLineStations("PLRT", PLRTStationsList),
  "PLRTB": generateLineStations("PLRTB", PLRTBranchStationsList),
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

Map<String, Color> lineColors = {
  "NSL": Colors.red,
  "EWL": Colors.green,
  "EWLB": Colors.green,
  "CCL": Colors.orange,
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
    //exists for junctions , so user not forced to look at wrong line
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
    if (index == -1) {
      index =
          EWLBranchStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index = BPLStationsList.indexWhere((station) => station == stationName);
    }
    if (index == -1) {
      index =
          BPLBranchStationsList.indexWhere((station) => station == stationName);
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
            onSelected: switchLine,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'NSL',
                child: Text('NSL'),
              ),
              const PopupMenuItem<String>(
                value: 'EWL',
                child: Text('EWL'),
              ),
              const PopupMenuItem<String>(
                value: 'EWLB',
                child: Text('EWLB'),
              ),
              const PopupMenuItem<String>(
                value: 'CCL',
                child: Text('CCL'),
              ),
              const PopupMenuItem<String>(
                value: 'NEL',
                child: Text('NEL'),
              ),
              const PopupMenuItem<String>(
                value: 'DTL',
                child: Text('DTL'),
              ),
              const PopupMenuItem<String>(
                value: 'BPL',
                child: Text('BPL'),
              ),
              const PopupMenuItem<String>(
                value: 'BPLB',
                child: Text('BPLB'),
              ),
              const PopupMenuItem<String>(
                value: 'SLRT',
                child: Text('SLRT'),
              ),
              const PopupMenuItem<String>(
                value: 'SLRTB',
                child: Text('SLRTB'),
              ),
              const PopupMenuItem<String>(
                value: 'PLRT',
                child: Text('PLRT'),
              ),
              const PopupMenuItem<String>(
                value: 'PLRTB',
                child: Text('PLRTB'),
              ),
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
                        currentStation = _selectedTrainStation.stnName;
                        CrowdedInfo = _getCrowdLevelForStation();
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
                  'Selected Station: ${_selectedTrainStation.stnName}',
                  style: kInfo,
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
                      currentStationIndex: find(currentStation),
                      currentLine: currentLine,
                      stationsz: stationsz,
                      lineColors: lineColors, // Pass lineColors here
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [],
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
