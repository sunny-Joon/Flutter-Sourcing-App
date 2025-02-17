import 'package:encrypt/encrypt.dart';

class EncryptionUtils {
  static const String _secretKey = "raghvendrapratap"; // Ensure this is exactly 16 bytes

  static String encrypt(String input) {
    final key = Key.fromUtf8(_secretKey.padRight(16, '\u0000').substring(0, 16)); // Ensure 16-byte key
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb)); // ECB mode does not use an IV
    final encrypted = encrypter.encrypt(input);
    return encrypted.base64;
  }

  static String decrypt(String encryptedInput) {
    try {
      final key = Key.fromUtf8(_secretKey.padRight(16, '\u0000').substring(0, 16)); // Ensure 16-byte key
      final encrypter = Encrypter(AES(key, mode: AESMode.ecb)); // ECB mode does not use an IV
      final decrypted = encrypter.decrypt64(encryptedInput);
      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return ""; // Handle error appropriately
    }
  }
}
