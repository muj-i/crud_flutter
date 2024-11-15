import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityChecker {
  static Future<bool> checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}
