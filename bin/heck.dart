import 'package:emulators/emulators.dart';

void main() async {
  final emulators = Emulators(await SDKConfig.loadDefaults());
  final skins = await emulators.listSkins();
  print('Skins: $skins');
  final images = await emulators.listSystemImages();
  print('Images: $images');
}
