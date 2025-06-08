import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ios_player_method_channel.dart';

abstract class IosPlayerPlatform extends PlatformInterface {
  /// Constructs a IosPlayerPlatform.
  IosPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static IosPlayerPlatform _instance = MethodChannelIosPlayer();

  /// The default instance of [IosPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelIosPlayer].
  static IosPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IosPlayerPlatform] when
  /// they register themselves.
  static set instance(IosPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
