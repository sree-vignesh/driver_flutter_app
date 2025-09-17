import 'package:url_launcher/url_launcher.dart';

class NavigationHelper {
  static Future<void> openGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );

    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  }
}
