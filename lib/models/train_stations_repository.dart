import 'dart:collection';

class TrainStation {
  String stnCode;
  String stnName;
  String trainLine;
  String trainLineCode;

  TrainStation({
    required this.stnCode,
    required this.stnName,
    required this.trainLine,
    required this.trainLineCode,
  });
}

class TrainStationsRepository {
  UnmodifiableListView<TrainStation> get allTrainStations {
    return UnmodifiableListView(_allTrainStations);
  }

  int get allTrainStationsCount {
    return _allTrainStations.length;
  }

  final List<TrainStation> _allTrainStations = [
    TrainStation(
        stnCode: "NS1",
        stnName: "Jurong East",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS2",
        stnName: "Bukit Batok",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS3",
        stnName: "Bukit Gombak",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS4",
        stnName: "Choa Chu Kang",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS5",
        stnName: "Yew Tee",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS7",
        stnName: "Kranji",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS8",
        stnName: "Marsiling",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS9",
        stnName: "Woodlands",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS10",
        stnName: "Admiralty",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS11",
        stnName: "Sembawang",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS12",
        stnName: "Canberra",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS13",
        stnName: "Yishun",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS14",
        stnName: "Khatib",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS15",
        stnName: "Yio Chu Kang",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS16",
        stnName: "Ang Mo Kio",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS17",
        stnName: "Bishan",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS18",
        stnName: "Braddell",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS19",
        stnName: "Toa Payoh",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS20",
        stnName: "Novena",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS21",
        stnName: "Newton",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS22",
        stnName: "Orchard",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS23",
        stnName: "Somerset",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS24",
        stnName: "Dhoby Ghaut",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS25",
        stnName: "City Hall",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS26",
        stnName: "Raffles Place",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS27",
        stnName: "Marina Bay",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "NS28",
        stnName: "Marina South Pier",
        trainLine: "North-South Line ",
        trainLineCode: "NSL"),
    TrainStation(
        stnCode: "EW1",
        stnName: "Pasir Ris",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW2",
        stnName: "Tampines",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW3",
        stnName: "Simei",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW4",
        stnName: "Tanah Merah",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW5",
        stnName: "Bedok",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW6",
        stnName: "Kembangan",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW7",
        stnName: "Eunos",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW8",
        stnName: "Paya Lebar",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW9",
        stnName: "Aljunied",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW10",
        stnName: "Kallang",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW11",
        stnName: "Lavender",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW12",
        stnName: "Bugis",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW13",
        stnName: "City Hall",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW14",
        stnName: "Raffles Place",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW15",
        stnName: "Tanjong Pagar",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW16",
        stnName: "Outram Park",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW17",
        stnName: "Tiong Bahru",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW18",
        stnName: "Redhill",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW19",
        stnName: "Queenstown",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW20",
        stnName: "Commonwealth",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW21",
        stnName: "Buona Vista",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW22",
        stnName: "Dover",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW23",
        stnName: "Clementi",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW24",
        stnName: "Jurong East",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW25",
        stnName: "Chinese Garden",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW26",
        stnName: "Lakeside",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW27",
        stnName: "Boon Lay",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW28",
        stnName: "Pioneer",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW29",
        stnName: "Joo Koon",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW30",
        stnName: "Gul Circle",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW31",
        stnName: "Tuas Crescent",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW32",
        stnName: "Tuas West Road",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "EW33",
        stnName: "Tuas Link",
        trainLine: "East-West Line",
        trainLineCode: "EWL"),
    TrainStation(
        stnCode: "CG1",
        stnName: "Expo",
        trainLine: "Changi Airport Branch Line",
        trainLineCode: "CGL"),
    TrainStation(
        stnCode: "CG2",
        stnName: "Changi Airport",
        trainLine: "Changi Airport Branch Line",
        trainLineCode: "CGL"),
    TrainStation(
        stnCode: "NE1",
        stnName: "HarbourFront",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE3",
        stnName: "Outram Park",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE4",
        stnName: "Chinatown",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE5",
        stnName: "Clarke Quay",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE6",
        stnName: "Dhoby Ghaut",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE7",
        stnName: "Little India",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE8",
        stnName: "Farrer Park",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE9",
        stnName: "Boon Keng",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE10",
        stnName: "Potong Pasir",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE11",
        stnName: "Woodleigh",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE12",
        stnName: "Serangoon",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE13",
        stnName: "Kovan",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE14",
        stnName: "Hougang",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE15",
        stnName: "Buangkok",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE16",
        stnName: "Sengkang",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "NE17",
        stnName: "Punggol",
        trainLine: "North East Line",
        trainLineCode: "NEL"),
    TrainStation(
        stnCode: "CC1",
        stnName: "Dhoby Ghaut",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC2",
        stnName: "Bras Basah",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC3",
        stnName: "Esplanade",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC4",
        stnName: "Promenade",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC5",
        stnName: "Nicoll Highway",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC6",
        stnName: "Stadium",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC7",
        stnName: "Mountbatten",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC8",
        stnName: "Dakota",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC9",
        stnName: "Paya Lebar",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC10",
        stnName: "MacPherson",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC11",
        stnName: "Tai Seng",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC12",
        stnName: "Bartley",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC13",
        stnName: "Serangoon",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC14",
        stnName: "Lorong Chuan",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC15",
        stnName: "Bishan",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC16",
        stnName: "Marymount",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC17",
        stnName: "Caldecott",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC19",
        stnName: "Botanic Gardens",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC20",
        stnName: "Farrer Road",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC21",
        stnName: "Holland Village",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC22",
        stnName: "Buona Vista",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC23",
        stnName: "one-north",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC24",
        stnName: "Kent Ridge",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC25",
        stnName: "Haw Par Villa",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC26",
        stnName: "Pasir Panjang",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC27",
        stnName: "Labrador Park",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC28",
        stnName: "Telok Blangah",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CC29",
        stnName: "HarbourFront",
        trainLine: "Circle Line",
        trainLineCode: "CCL"),
    TrainStation(
        stnCode: "CE1",
        stnName: "Bayfront",
        trainLine: "Circle Line Extension",
        trainLineCode: "CEL"),
    TrainStation(
        stnCode: "CE2",
        stnName: "Marina Bay",
        trainLine: "Circle Line Extension",
        trainLineCode: "CEL"),
    TrainStation(
        stnCode: "DT1",
        stnName: "Bukit Panjang",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT2",
        stnName: "Cashew",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT3",
        stnName: "Hillview",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT5",
        stnName: "Beauty World",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT6",
        stnName: "King Albert Park",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT7",
        stnName: "Sixth Avenue",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT8",
        stnName: "Tan Kah Kee",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT9",
        stnName: "Botanic Gardens",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT10",
        stnName: "Stevens",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT11",
        stnName: "Newton",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT12",
        stnName: "Little India",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT13",
        stnName: "Rochor",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT14",
        stnName: "Bugis",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT15",
        stnName: "Promenade",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT16",
        stnName: "Bayfront",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT17",
        stnName: "Downtown",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT18",
        stnName: "Telok Ayer",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT19",
        stnName: "Chinatown",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT20",
        stnName: "Fort Canning",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT21",
        stnName: "Bencoolen",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT22",
        stnName: "Jalan Besar",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT23",
        stnName: "Bendemeer",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT24",
        stnName: "Geylang Bahru",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT25",
        stnName: "Mattar",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT26",
        stnName: "MacPherson",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT27",
        stnName: "Ubi",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT28",
        stnName: "Kaki Bukit",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT29",
        stnName: "Bedok North",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT30",
        stnName: "Bedok Reservoir",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT31",
        stnName: "Tampines West",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT32",
        stnName: "Tampines",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT33",
        stnName: "Tampines East",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT34",
        stnName: "Upper Changi",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "DT35",
        stnName: "Expo",
        trainLine: "Downtown Line",
        trainLineCode: "DTL"),
    TrainStation(
        stnCode: "BP1",
        stnName: "Choa Chu Kang",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP2",
        stnName: "South View",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP3",
        stnName: "Keat Hong",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP4",
        stnName: "Teck Whye",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP5",
        stnName: "Phoenix",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP6",
        stnName: "Bukit Panjang",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP7",
        stnName: "Petir",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP8",
        stnName: "Pending",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP9",
        stnName: "Bangkit",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP10",
        stnName: "Fajar",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP11",
        stnName: "Segar",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP12",
        stnName: "Jelapang",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "BP13",
        stnName: "Senja",
        trainLine: "Bukit Panjang LRT",
        trainLineCode: "BPL"),
    TrainStation(
        stnCode: "STC",
        stnName: "Sengkang",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SE1",
        stnName: "Compassvale",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SE2",
        stnName: "Rumbia",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SE3",
        stnName: "Bakau",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SE4",
        stnName: "Kangkar",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SE5",
        stnName: "Ranggung",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW1",
        stnName: "Cheng Lim",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW2",
        stnName: "Farmway",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW3",
        stnName: "Kupang",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW4",
        stnName: "Thanggam",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW5",
        stnName: "Fernvale",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW6",
        stnName: "Layar",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW7",
        stnName: "Tongkang",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "SW8",
        stnName: "Renjong",
        trainLine: "Sengkang LRT",
        trainLineCode: "SLRT"),
    TrainStation(
        stnCode: "PTC",
        stnName: "Punggol",
        trainLine: "Punggol LRT",
        trainLineCode: "PLRT"),
    TrainStation(
        stnCode: "PE1",
        stnName: "Cove",
        trainLine: "Punggol LRT",
        trainLineCode: "PLRT"),
    TrainStation(
      stnCode: "PE2",
      stnName: "Meridian",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PE3",
      stnName: "Coral Edge",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PE4",
      stnName: "Riviera",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PE5",
      stnName: "Kadaloor",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PE6",
      stnName: "Oasis",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PE7",
      stnName: "Damai",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PW1",
      stnName: "Sam Kee",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PW3",
      stnName: "Punggol Point",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PW4",
      stnName: "Samudera",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PW5",
      stnName: "Nibong",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PW6",
      stnName: "Sumang",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    ),
    TrainStation(
      stnCode: "PW7",
      stnName: "Soo Teck",
      trainLine: "Punggol LRT",
      trainLineCode: "PLRT",
    )
  ];
}
