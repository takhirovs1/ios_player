import 'package:flutter/services.dart';

/// Foydalanishga tayyor oddiy wrapper.
/// Kerak bo‘lsa, [play], [pause], [seekTo] va h.k. funksiyalarni kengaytiring.
class IosPlayer {
  IosPlayer._(); // static-only

  static const MethodChannel _channel = MethodChannel('ios_player');

  /// iOS tomonda SwiftUI pleerni ochadi.
  static Future<void> open({required String url}) async {
    await _channel.invokeMethod('openPlayer', {'url': url});
  }

  /// Vidеoni davom ettirish.
  static Future<void> play() => _channel.invokeMethod('play');

  /// Vidеoni to‘xtatib turish.
  static Future<void> pause() => _channel.invokeMethod('pause');
}
