import 'package:web/web.dart';

Future<bool> checkNetworkConnection() async {
  return window.navigator.onLine;
}
