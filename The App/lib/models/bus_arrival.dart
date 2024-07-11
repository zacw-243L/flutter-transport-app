class BusArrival {
  String serviceNo;
  NextBus nextBus;
  NextBus? nextBus2;
  NextBus? nextBus3; // Make nextBus3 nullable

  BusArrival({
    required this.serviceNo,
    required this.nextBus,
    this.nextBus2, // Make nextBus2 nullable in constructor
    this.nextBus3, // Make nextBus3 nullable in constructor
  });

  factory BusArrival.fromJson(Map<String, dynamic> json) {
    return BusArrival(
      serviceNo: json['ServiceNo'],
      nextBus: NextBus.fromJson(json['NextBus']),
      nextBus2:
          json['NextBus2'] != null ? NextBus.fromJson(json['NextBus2']) : null,
      nextBus3:
          json['NextBus3'] != null ? NextBus.fromJson(json['NextBus3']) : null,
    );
  }
}

class NextBus {
  String estimatedArrival;
  String load;
  String feature;
  String type;

  NextBus({
    required this.estimatedArrival,
    required this.load,
    required this.feature,
    required this.type,
  });

  factory NextBus.fromJson(Map<String, dynamic> json) {
    return NextBus(
      estimatedArrival: json['EstimatedArrival'],
      load: json['Load'],
      feature: json['Feature'],
      type: json['Type'],
    );
  }
}
