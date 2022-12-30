import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class FavoriteSongs extends StatelessWidget {

  final List<SongInfo> favSongsList;

  const FavoriteSongs({Key? key, required this.favSongsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SongInfo songInfo;

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: favSongsList.length,
          itemBuilder: (context, index) {

        return ListTile(title: Text(favSongsList[index].title),);
      }),
    );
  }
}
