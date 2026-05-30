import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_MAP_KEY', obfuscate: true)
  static String googleMapKey = _Env.googleMapKey;
}
