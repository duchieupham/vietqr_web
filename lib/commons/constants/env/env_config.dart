import 'package:VietQR/commons/constants/env/evn.dart';
import 'package:VietQR/commons/constants/env/prod_evn.dart';
import 'package:VietQR/commons/constants/env/stg_env.dart';
import 'package:VietQR/commons/enums/env_type.dart';
// import 'package:firebase_core/firebase_core.dart';

class EnvConfig {
  static final Env _env = (getEnv() == EnvType.STG) ? StgEnv() : ProdEnv();

  static String getBankUrl() {
    return _env.getBankUrl();
  }

  static String getBaseUrl() {
    return _env.getBaseUrl();
  }

  static String getUrl() {
    return _env.getUrl();
  }

  // static FirebaseOptions getFirebaseConfig() {
  //   return _env.getFirebaseCongig();
  // }

  static EnvType getEnv() {
    // const EnvType env = EnvType.STG;
    const EnvType env = EnvType.PROD;
    return env;
  }
}
