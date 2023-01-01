// @dart=2.9

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesomemusicplayer/screens/favorite_songs.dart';
import 'package:awesomemusicplayer/screens/now_playing.dart';
import 'package:awesomemusicplayer/screens/songs_list_screen.dart';
import 'package:awesomemusicplayer/themes/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List _bottomNavViewport = [];

  bool isFavoriteSong = false;

  final key = GlobalKey();

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> listOfSongs = [];
  List<SongInfo> favSongs = [];

  final player = AssetsAudioPlayer();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Future<void> playSong(String fileURI) async {
  //   await player.open(Audio.file(fileURI)).then((value) {
  //     player.play();
  //   }).onError((error, stackTrace) {
  //     if (kDebugMode) {
  //       print(error.toString());
  //     }
  //   });
  // }

  void initializeBottomNavView() {
    _bottomNavViewport.addAll([
      const Text('1'),
      LocalSongs(listOfSongs: listOfSongs),
    ]);
  }

  Future<List<SongInfo>> getListOfAllSongs() async {
    List<SongInfo> songsList = await audioQuery.getSongs();
    if (songsList.isNotEmpty) {
      setState(() {
        listOfSongs = songsList;
      });
    } else {
      throw Exception('No songs found!');
    }
    return songsList;
  }

  Future favoriteSongs(SongInfo songId) async {
    print(isFavoriteSong);
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await _prefs;
    if (!isFavoriteSong) {
      setState(() {
        isFavoriteSong = true;
        favSongs.add(songId);
      });
      await prefs.setBool(songId.id, true);

      if (kDebugMode) {
        print(favSongs.length);
      }
    } else {
      setState(() {
        isFavoriteSong = false;
        favSongs.remove(songId);
      });
      await prefs.setBool(songId.id, false);
    }
    print(favSongs.length);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getListOfAllSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: veryLightPink,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  //color: Color.fromRGBO(160, 160, 160, 0.6),
                  color: darkPink,
                  spreadRadius: 2,
                  blurStyle: BlurStyle.outer,
                  offset: Offset(0, 0),
                  blurRadius: 2,
                ),
              ]),
          child: Material(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.transparent,
            elevation: 0.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: BottomNavigationBar(
                  unselectedLabelStyle: const TextStyle(shadows: [
                    BoxShadow(blurRadius: 5, spreadRadius: 5, color: pinkShadow)
                  ]),
                  selectedLabelStyle: const TextStyle(shadows: [
                    BoxShadow(blurRadius: 5, spreadRadius: 5, color: pinkShadow)
                  ]),
                  elevation: 3.0,
                  selectedItemColor: darkPink,
                  backgroundColor: lightPink,
                  onTap: onTapFunction,
                  currentIndex: _currentIndex,
                  items: const [
                    BottomNavigationBarItem(
                      label: 'Music',
                      icon: Icon(Icons.music_note, shadows: [
                        BoxShadow(
                            blurRadius: 5, spreadRadius: 5, color: pinkShadow)
                      ]),
                    ),
                    BottomNavigationBarItem(
                      label: 'Chat',
                      icon: Icon(Icons.chat_bubble_outline, shadows: [
                        BoxShadow(
                            blurRadius: 5, spreadRadius: 5, color: pinkShadow)
                      ]),
                    ),
                  ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightPink,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FavoriteSongs(favSongsList: favSongs),
            ),
          );
        },
        // shape: BeveledRectangleBorder(
        //   borderRadius: BorderRadius.circular(16.0),
        //   // side: const BorderSide(
        //   //     style: BorderStyle.solid, color: darkPink, width: 1),
        // ),
        shape: const StadiumBorder(
            side: BorderSide(
                width: 0.5, color: darkPink, style: BorderStyle.solid)),
        child: const Icon(
          Icons.favorite,
          size: 28,
          color: darkPink,
          shadows: [
            BoxShadow(blurRadius: 5, spreadRadius: 5, color: pinkShadow)
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: listOfSongs.length,
          itemBuilder: (context, index) {
            final song = listOfSongs[index];
            var title = song.title.replaceAll('(Pagalworld.pw)', '');
            var artist = song.artist.replaceAll('(Pagalworld.pw)', '');

            return ListTile(
              contentPadding: const EdgeInsets.only(top: 5, bottom: 0),
              isThreeLine: false,
              onTap: () {
                //playSong(song.uri);
                setState(() {
                  player.open(Audio.file(song.uri));
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlaying(
                      currentPlayingSongInfo: song,
                      player: player,
                    ),
                  ),
                );
                if (player.isPlaying != null) {
                  player.stop();
                } else {
                  player.play();
                  if (kDebugMode) {
                    print(player.isPlaying.value);
                  }
                }
              },
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                // child: Image.asset('assets/albumart.jpg'),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(180),
                    child: Image.asset('assets/albumart.jpg')),
              ),
              title: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: darkPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                artist,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: lightBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: IconButton(
                onPressed: () async {
                  await favoriteSongs(song);
                },
                icon: isFavoriteSong
                    ? const Icon(
                        Icons.favorite,
                        color: darkPink,
                      )
                    : const Icon(
                        Icons.favorite_outline,
                        color: darkPink,
                      ),
              ),
            );
          }),
    );
  }

  void onTapFunction(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
