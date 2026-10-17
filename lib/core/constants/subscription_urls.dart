import 'package:url_launcher/url_launcher.dart';

abstract final class SubscriptionUrls {
  static const playSubscriptions =
      'https://play.google.com/store/account/subscriptions';

  static Future<void> openPlaySubscriptions() async {
    final uri = Uri.parse(playSubscriptions);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}
