import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3372845461259170/4147982505';
    } else if (Platform.isIOS) {
      return '<iOS Banner Ad Unit ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}