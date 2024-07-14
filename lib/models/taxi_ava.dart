class TaxiAVA {
  double latitude;
  double longitude;

  TaxiAVA({
    required this.latitude,
    required this.longitude,
  });

  factory TaxiAVA.fromJson(Map<String, dynamic> json) {
    return TaxiAVA(
      latitude: json['Latitude'],
      longitude: json['Longitude'],
    );
  }
}
