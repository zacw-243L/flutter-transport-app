class BusStop {
  String busStopCode;
  String roadName;
  String description;
  double latitude;
  double longitude;

  BusStop({
    required this.busStopCode,
    required this.roadName,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      busStopCode: json['BusStopCode'],
      roadName: json['RoadName'],
      description: json['Description'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
    );
  }
}
