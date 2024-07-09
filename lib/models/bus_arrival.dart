class BusArrival {
  String serviceNo;
  NextBus nextBus;

  BusArrival({
    required this.serviceNo,
    required this.nextBus,
  });

  // JSON response returns the timestamp that the next bus will arrive
  // The computeArrival function calculates the difference between the timestamp and current time &
  // returns the difference in minutes.

  // factory BusArrival.fromJson(Map<String, dynamic> json) {
  //   String computeArrival(String estimatedArrival) {
  //     if (estimatedArrival != '') {
  //       var nextBus = DateTime.parse(estimatedArrival);
  //       var difference = nextBus.difference(DateTime.now()).inMinutes;
  //       return difference.toString();
  //     }
  //     return '';
  //   }
  // }

  factory BusArrival.fromJson(Map<String, dynamic> json) {
    return BusArrival(
      serviceNo: json['ServiceNo'],
      nextBus: NextBus.fromJson(json['NextBus']),
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
