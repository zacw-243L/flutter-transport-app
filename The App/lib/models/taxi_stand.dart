class TaxiStand {
  String name;
  double latitude;
  double longitude;

  TaxiStand({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  // TODO implement TaxiStand.fromJson
  factory TaxiStand.fromJson(Map<String, dynamic> json) {
    return TaxiStand(
      name: json['Name'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
    );
  }
}
