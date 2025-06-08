import 'package:flutter/material.dart';
import 'package:ios_player/ios_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('iOS Player demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => IosPlayer.open(
                  url: 'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
                ),
                child: const Text('Pleer ochish'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: IosPlayer.play,
                child: const Text('Play'),
              ),
              ElevatedButton(
                onPressed: IosPlayer.pause,
                child: const Text('Pause'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
