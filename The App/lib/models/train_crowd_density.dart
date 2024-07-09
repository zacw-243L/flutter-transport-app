class CrowdDensity {
  String station;
  String crowdLevel;

  CrowdDensity({
    required this.station,
    required this.crowdLevel,
  });

  // TODO implement CrowdDensity.fromJson
  factory CrowdDensity.fromJson(Map<String, dynamic> json) {
    return CrowdDensity(
      station: json['Station'],
      crowdLevel: json['CrowdLevel'],
    );
  }
}
