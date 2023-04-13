import 'package:VietQR/commons/constants/env/evn.dart';
import 'package:firebase_core/firebase_core.dart';

class ProdEnv implements Env {
  @override
  String getBankUrl() {
    return '';
  }

  @override
  String getBaseUrl() {
    return 'http://112.78.1.209:8084/vqr/api/';
  }

  @override
  String getUrl() {
    return 'http://112.78.1.209:8084/vqr/';
  }

  @override
  FirebaseOptions getFirebaseCongig() {
    return const FirebaseOptions(
      apiKey: "AIzaSyAjPP6Mc3baFUgEsO8o0-J-qmSVegmw2TQ",
      appId: "1:84188087131:web:79177d863a3480e04ed07e",
      messagingSenderId: '84188087131',
      projectId: 'vietqr-product',
    );
  }
}
