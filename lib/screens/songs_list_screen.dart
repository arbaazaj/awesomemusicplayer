// @dart=2.9

import 'package:awesomemusicplayer/screens/now_playing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class LocalSongs extends StatelessWidget {
  const LocalSongs({Key key, @required this.listOfSongs}) : super(key: key);

  final List<SongInfo> listOfSongs;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: listOfSongs.cast() as Stream,
        builder: (context, snapshot) {
          if (!snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: listOfSongs.length,
                itemBuilder: (context, index) {
                  final song = listOfSongs[index];
                  return ListTile(
                    title: Text(song.title),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator(),);
        }
    );
  }
}
