import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ios_player_platform_interface.dart';

/// An implementation of [IosPlayerPlatform] that uses method channels.
class MethodChannelIosPlayer extends IosPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ios_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
