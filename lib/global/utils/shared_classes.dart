import 'dart:math';

class Processors {
  static String generateCode(int length) {
    const String charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String code = '';

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(charset.length);
      code += charset[randomIndex];
    }

    return code;
  }
}
