class Common {
  static int convertStringtoInt(String? value) {
    if (value == null) {
      return 0;
    }
    return double.parse(value).toInt();
  }
}
