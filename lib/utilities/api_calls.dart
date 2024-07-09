import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/bus_arrival.dart';
import '../models/bus_stop.dart';
import '../models/train_crowd_density.dart';
import '../models/taxi_stand.dart';

class ApiCalls {
  Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    //TODO
  };

  // Refer to 2.4 Bus Stops
  Future<List<BusStop>> fetchBusStops() async {
    String baseURL = 'http://datamall2.mytransport.sg/ltaodataservice/BusStops';

    final response =
        await http.get(Uri.parse(baseURL), headers: requestHeaders);

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> jsonList = jsonDecode(response.body)['value'];
      List<BusStop> busStops =
          jsonList.map((json) => BusStop.fromJson(json)).toList();
      return busStops; // TODO return List<BusStop>
    } else {
      throw Exception('Failed to load bus stops');
    }
  }

/*  // Refer to 2.1 Bus Arrival needs param
  void fetchBusArrival() async {
    // TODO return List<BusArrival>
  }*/

  // Refer to 2.1 Bus Arrival
  Future<List<BusArrival>> fetchBusArrivals(String busStopCode) async {
    String baseURL =
        'http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=$busStopCode';

    final response =
        await http.get(Uri.parse(baseURL), headers: requestHeaders);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body)['Services'];
      List<BusArrival> busArrivals =
          jsonList.map((json) => BusArrival.fromJson(json)).toList();

      return busArrivals;
    } else {
      throw Exception('Failed to load bus arrivals');
    }
  }

  // Refer to 2.25 Platform Crowd Density needs params
  void fetchCrowdDensity() async {
    // TODO return List<CrowdDensity>
  }

  // Refer to 2.10 Taxi Stands
  Future<List<TaxiStand>> fetchTaxiStands() async {
    String baseURL =
        'http://datamall2.mytransport.sg/ltaodataservice/TaxiStands';

    final response =
        await http.get(Uri.parse(baseURL), headers: requestHeaders);

    if (response.statusCode == 200) {
      // TODO return List<TaxiStand>
      print(response.body);
      List<dynamic> jsonList = jsonDecode(response.body)['value'];
      List<TaxiStand> taxistand =
          jsonList.map((json) => TaxiStand.fromJson(json)).toList();
      return taxistand;
    } else {
      throw Exception('Failed to load Taxi Stand');
    }
  }
}
