class Helpers {

  static bool isBrightColor(String myColorString) {
    myColorString = myColorString.replaceAll("#", "");
    int color = int.parse(myColorString, radix: 16);
    return color > 7500000;

  }
}