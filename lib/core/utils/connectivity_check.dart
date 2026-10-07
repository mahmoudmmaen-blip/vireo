import 'connectivity_check_stub.dart'
    if (dart.library.io) 'connectivity_check_io.dart'
    if (dart.library.html) 'connectivity_check_web.dart';

/// Returns whether the device likely has network access.
Future<bool> hasNetworkConnection() => checkNetworkConnection();
