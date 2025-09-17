import 'package:url_launcher/url_launcher.dart';

class NavigationHelper {
  static Future<void> openGoogleMaps(
    double lat,
    double lng, {
    String label = "",
  }) async {
    final encodedLabel = Uri.encodeComponent(label);
    final Uri geoUri = Uri.parse("geo:$lat,$lng?q=$lat,$lng($encodedLabel)");
    final Uri webUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    try {
      // Launch native map app
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Fallback → browser
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}
