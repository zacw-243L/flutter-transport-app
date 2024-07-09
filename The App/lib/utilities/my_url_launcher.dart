import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

Future<void> openMap(double lat, double lng) async {
  try {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    await launchURL(url);
  } catch (e) {
    print('Error opening map: $e');
    throw Exception('Could not launch Google Maps');
  }
}
