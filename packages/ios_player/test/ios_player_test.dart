import 'package:flutter_test/flutter_test.dart';
import 'package:ios_player/ios_player.dart';
import 'package:ios_player/ios_player_platform_interface.dart';
import 'package:ios_player/ios_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIosPlayerPlatform
    with MockPlatformInterfaceMixin
    implements IosPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IosPlayerPlatform initialPlatform = IosPlayerPlatform.instance;

  test('$MethodChannelIosPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIosPlayer>());
  });

  test('getPlatformVersion', () async {
    // IosPlayer iosPlayerPlugin = IosPlayer.open(url: 'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8');
    MockIosPlayerPlatform fakePlatform = MockIosPlayerPlatform();
    IosPlayerPlatform.instance = fakePlatform;

    // expect(await iosPlayerPlugin.getPlatformVersion(), '42');
  });
}
