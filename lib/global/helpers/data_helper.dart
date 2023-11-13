class DataHelper {
  static int countFromMap(List<Map<String, dynamic>> count) {
    if (count.isEmpty) {
      return 0;
    }

    int sum = 0;

    for (int i = 0; i < count.length; i++) {
      final int c = count[i]['count'];
      sum += c;
    }
    return sum;
  }

  // return Map<String, dynamic>
  static Map<String, dynamic> countToMap(String color, int count) {
    Map<String, dynamic> generated = {};

    generated['count'] = count;
    generated['color'] = color;

    return generated;
  }
}
