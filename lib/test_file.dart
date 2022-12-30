import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class TestingNowPlayingWithStream extends StatefulWidget {
  final SongInfo playingSong;
  final AssetsAudioPlayer player;

  const TestingNowPlayingWithStream({Key? key, required this.playingSong, required this.player})
      : super(key: key);

  @override
  State<TestingNowPlayingWithStream> createState() =>
      _TestingNowPlayingWithStreamState();
}

class _TestingNowPlayingWithStreamState
    extends State<TestingNowPlayingWithStream> {
  late SongInfo currentSong;
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  late AssetsAudioPlayer audioPlayer;

  @override
  void initState() {

    super.initState();
    setState(() {
      currentSong = widget.playingSong;
    });
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer = widget.player;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
      ),
      body: StreamBuilder<Playing>(
          stream: audioPlayer.current as Stream<Playing>,
          builder: (_, snapshot) {
            if (kDebugMode) {
              Metas? metas = snapshot.data?.audio.audio.metas;
              print(currentSong);
            }
            if (snapshot.data != null) {
              return Text('${snapshot.data?.audio.audio.metas.title}');
            }
            return Container();
          }
      )
    );
  }

  void onPressed() {
    if (kDebugMode) {
      print(currentSong.albumId);
    }
  }
}
