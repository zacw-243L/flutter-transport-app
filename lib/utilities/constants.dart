import 'package:flutter/material.dart';

// Colors
const Color kPrimaryColor = Color(0xFF5E60CE);
const Color kWhiteColor = Color(0xFFFFFFFF);
const List<String> CELStationsList = [
  "Bayfront",
  "Marina Bay",
];
const List<String> CGLStationsList = [
  "Expo",
  "Changi Airport",
];
const List<String> BPLStationsList = [
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
const List<String> SLRTStationsList = [
  "Sengkang",
  "Cheng Lim",
  "Farmway",
  "Kupang",
  "Thanggam",
  "Fernvale",
  "Layar",
  "Tongkang",
  "Renjong",
  "Sengkang",
  "Compassvale",
  "Rumbia",
  "Bakau",
  "Kangkar",
  "Ranggung",
  "Sengkang",
];
const List<String> PLRTStationsList = [
  "Punggol",
  "Cove",
  "Meridian",
  "Coral Edge",
  "Riviera",
  "Kadaloor",
  "Oasis",
  "Damai",
  "Punggol",
  "Sam Kee",
  "Punggol Point",
  "Samudera",
  "Nibong",
  "Sumang",
  "Soo Teck",
  "Punggol",
];
const List<String> NSLStationsList = [
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
const List<String> EWLStationsList = [
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
const List<String> CCLStationsList = [
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
const List<String> NELStationsList = [
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
const List<String> DTLStationsList = [
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

// Text Styles
const TextStyle kAppName = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: kWhiteColor,
);
const TextStyle kShowMap = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
);

const TextStyle kWelcomeUser = TextStyle(
  fontSize: 18,
  color: kWhiteColor,
);

const TextStyle kInfo = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: kWhiteColor,
);

const TextStyle kbiggertimer = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: kWhiteColor,
  shadows: [
    Shadow(
      offset: Offset(2.0, 2.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],
);

const TextStyle ksmallerinfo = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: Colors.white70,
  shadows: [
    Shadow(
      offset: Offset(2.0, 2.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],
);
const TextStyle kShadowRed = TextStyle(
  color: Color(0xFFC60B0B), // A deep red color
  fontSize: 18, // Bigger font size
  shadows: [
    Shadow(
      offset: Offset(2.0, 2.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],
);
const TextStyle kShadowRed2 = TextStyle(
  color: Color(0xFFFF0000), // Deep red color
  fontSize: 20, // Bigger font size
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      offset: Offset(2.0, 2.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],
);

const TextStyle kShadow = TextStyle(
  color: Colors.white,
  fontSize: 22,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      offset: Offset(2.0, 2.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],
);
const TextStyle kShadow2 = TextStyle(
  color: Colors.white,
  fontSize: 16,
  shadows: [
    Shadow(
      offset: Offset(2.0, 2.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ],
);
const TextStyle kAccessible = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: kWhiteColor,
);

const TextStyle kBusTitle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: kWhiteColor,
);

// Other constants
const double kPadding = 14.0;
