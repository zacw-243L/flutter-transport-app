class CrowdDensity {
  String station;
  String crowdLevel;

  CrowdDensity({
    required this.station,
    required this.crowdLevel,
  });

  factory CrowdDensity.fromJson(Map<String, dynamic> json) {
    return CrowdDensity(
      station: json['Station'],
      crowdLevel: json['CrowdLevel'],
    );
  }
}
