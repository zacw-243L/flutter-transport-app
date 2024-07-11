class BusArrival {
  String serviceNo;
  NextBus nextBus;
  NextBus nextBus2;
  NextBus nextBus3;

  BusArrival({
    required this.serviceNo,
    required this.nextBus,
    required this.nextBus2,
    required this.nextBus3,
  });

  factory BusArrival.fromJson(Map<String, dynamic> json) {
    return BusArrival(
      serviceNo: json['ServiceNo'],
      nextBus: NextBus.fromJson(json['NextBus']),
      nextBus2: NextBus.fromJson(json['NextBus2']),
      nextBus3: NextBus.fromJson(json['NextBus3']),
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
