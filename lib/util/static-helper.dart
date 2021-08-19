import 'package:connectivity_plus/connectivity_plus.dart';

class Helpers {

  static bool isBrightColor(String myColorString) {
    myColorString = myColorString.replaceAll("#", "");
    int color = int.parse(myColorString, radix: 16);
    return color > 7500000;

  }

  static Future<bool> hasNetworkConnection() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      // this will throw exception on integration testing
      return true;
    }
  }
}