import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';

class AESConvert {
  String keyAES = 'keyencryptdevietqrloginqrbyaes01';
  String encrypt(String value) {
    final key = Key.fromUtf8(keyAES);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));

    final encrypted = encrypter.encrypt(value, iv: iv);
    print('Encrypted: ${encrypted.base64}');
    return encrypted.base64;
  }

  decrypt(String value) {
    final key = Key.fromUtf8(keyAES);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt64(value, iv: iv);
    print('Decrypted: $decrypted');
  }

  String getEncryptedString(String loginID, String randomKey) {
    Uuid uuid = const Uuid();
    String accessKey = 'VIETQRVNBNSAccessKeyForLoginWEB';
    return 'LOGIN$randomKey$accessKey$loginID';
  }

  String getLoginID() {
    Uuid uuid = const Uuid();
    String loginId = uuid.v4();
    return loginId;
  }

  String getRandomKey() {
    Uuid uuid = const Uuid();
    String randomKey = uuid.v4();
    return randomKey;
  }
}
