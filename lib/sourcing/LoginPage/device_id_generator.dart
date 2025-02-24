import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String> generateDeviceId(String userid) async {
  final deviceInfo = DeviceInfoPlugin();



  String lastThreeChars = '';

  if (userid.trim().length > 3) {
    lastThreeChars = userid.trim().substring(userid.trim().length - 3);
  }

  String board = '', brand = '', cpuAbi = '', device = '', display = '';
  String host = '', id = '', manufacturer = '', model = '', product = '';
  String tags = '', type = '', user = '';

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    board = androidInfo.board ?? '';
    brand = androidInfo.brand ?? '';
    cpuAbi = androidInfo.supportedAbis.first ?? ''; // CPU ABI can be multiple, taking the first one
    device = androidInfo.device ?? '';
    display = androidInfo.display ?? '';
    host = androidInfo.host ?? '';
    id = androidInfo.id ?? '';
    manufacturer = androidInfo.manufacturer ?? '';
    model = androidInfo.model ?? '';
    product = androidInfo.product ?? '';
    tags = androidInfo.tags ?? '';
    type = androidInfo.type ?? '';
    user = androidInfo.fingerprint ?? '';
  }

  String deviceId = lastThreeChars +
      (board.length % 10).toString() +
      (brand.length % 10).toString() +
      (cpuAbi.length % 10).toString() +
      (device.length % 10).toString() +
      (display.length % 10).toString() +
      (host.length % 10).toString() +
      (id.length % 10).toString() +
      (manufacturer.length % 10).toString() +
      (model.length % 10).toString() +
      (product.length % 10).toString() +
      (tags.length % 10).toString() +
      (type.length % 10).toString() +
      (user.length % 10).toString();
  print(deviceId);

  deviceId = '2234514145687247';

  return deviceId;
}
