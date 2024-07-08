import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

Future<void> openMap(double lat, double lng) async {
  Uri uri =
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch Google Maps';
  }
}
