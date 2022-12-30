import 'dart:async';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesomemusicplayer/themes/colors.dart';
import 'package:awesomemusicplayer/widgets/glowing_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:awesomemusicplayer/utils/visualizer.dart';

class NowPlaying extends StatelessWidget {
  final SongInfo? currentPlayingSongInfo;
  final AssetsAudioPlayer? player;

  const NowPlaying({Key? key, this.currentPlayingSongInfo, this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: lightCream),
        centerTitle: true,
        title: const Text(
          'Now Playing',
          style: TextStyle(color: lightCream),
        ),
        foregroundColor: lightViolet,
        backgroundColor: darkBlue,
        elevation: 10,
      ),
      body: BuildBody(
          currentPlayingSongInfo: currentPlayingSongInfo, player: player),
    );
  }
}

class BuildBody extends StatefulWidget {
  final SongInfo? currentPlayingSongInfo;
  final AssetsAudioPlayer? player;

  const BuildBody({Key? key, required this.currentPlayingSongInfo, this.player})
      : super(key: key);

  @override
  State<BuildBody> createState() => _BuildBodyState();
}

enum Repeat { repeatOff, repeatSingle, repeatAll }

class _BuildBodyState extends State<BuildBody> with TickerProviderStateMixin {
  double sliderValue = 0.0;
  bool isPlaying = true;
  Icon repeatIcon = const Icon(Icons.repeat);
  late String songDuration;

  Future<void> songDur() async {
    var minute = widget.player?.current.value?.audio.duration.inMinutes
        .remainder(Duration.minutesPerHour);
    var seconds = widget.player?.current.value?.audio.duration.inSeconds
        .remainder(Duration.secondsPerMinute);
    setState(() {
      songDuration = '$minute:$seconds';
    });
  }

  @override
  void initState() {
    super.initState();
    songDur();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Album art
        Padding(
          padding: const EdgeInsets.all(42.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(180),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.zero,
              decoration:  const BoxDecoration(
                color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 8,
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer)
                  ]),
              child: Image.asset(
                'assets/albumart.jpg',
              ),
            ),
          ),
        ),
        // Progress Indicator with song duration
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              // Current Song duration in text (Start time).
              child: Text(
                '0.00',
                style: TextStyle(color: lightCream),
              ),
            ),
            Flexible(
              // Current Song Progress Bar.TODO:
              child: Slider(
                max: 1.0,
                inactiveColor: lightCream,
                activeColor: lightViolet,
                value: sliderValue,
                onChanged: onChangedSliderValue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              // Current Song duration in text (End time).
              child:
                  Text(songDuration, style: const TextStyle(color: lightCream)),
            ),
          ],
        ),
        // Song title
        Padding(
          padding: const EdgeInsets.all(8.0),
          // Song title
          child: Text(
            '${widget.currentPlayingSongInfo?.title}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Song artist
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          // Song artist name
          child: Text(
            '${widget.currentPlayingSongInfo?.artist}',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        // Player Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Skip to previous song button.
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: lightViolet,
                  elevation: 16,
                  shape: const StadiumBorder(),
                ),
                onPressed: previousSong,
                child: const Icon(Icons.skip_previous)),
            // Play and pause combo button.
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: lightViolet,
                elevation: 16,
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
              ),
              onPressed: playOrPause,
              child: isPlaying
                  ? const Icon(Icons.pause, size: 28)
                  : const Icon(Icons.play_arrow, size: 28),
            ),
            // Skip to next song button.
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: lightViolet,
                  elevation: 16,
                  shape: const StadiumBorder(),
                ),
                onPressed: nextSong,
                child: const Icon(
                  Icons.skip_next,
                )),
          ],
        ),
        const SizedBox(height: 20),
        // Repeat, Stop and Shuffle control buttons.
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Repeat button with all three stages (Off, All Songs, Single Song).
              IconButton(
                onPressed: onPressedRepeat,
                icon: currentRepeatState == Repeat.repeatOff
                    ? const Icon(CupertinoIcons.repeat, color: lightCream)
                    : currentRepeatState == Repeat.repeatAll
                        ? const GlowingIcon()
                        : currentRepeatState == Repeat.repeatSingle
                            ? const Icon(CupertinoIcons.repeat_1,
                                color: lightCream)
                            : const Icon(CupertinoIcons.repeat,
                                color: lightCream),
              ),
              // Stop button to stop currently playing song TODO:(Probably be removed in production).
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: lightViolet,
                  elevation: 16,
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                ),
                onPressed: onPressedStopped,
                child: const Icon(
                  Icons.stop,
                  size: 28,
                ),
              ),
              // Shuffle button.
              IconButton(
                  onPressed: onPressedShuffle,
                  icon: const Icon(
                    Icons.shuffle,
                    color: lightCream,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Flexible(
          fit: FlexFit.tight,
          child: Align(
            heightFactor: double.infinity,
            alignment: Alignment.bottomCenter,
            child: MusicVisualizer(
              width: 2,
              colors: colors,
              duration: duration,
              barCount: 80,
            ),
          ),
        ),
      ],
    );
  }

  final List<Color> colors = [
    lightViolet,
    lightCream,
    lightViolet,
    lightCream,
  ];
  final List<int> duration = [
    1200,
    1100,
    1000,
    900,
    800,
    700,
    600,
    700,
    800,
    900,
    1000,
    1100,
  ];

  void currentSongDuration() {}

  // OnClicked Previous song button method.
  void previousSong() {}

  // OnClicked PlayOrPause song button method.
  void playOrPause() {
    if (isPlaying) {
      setState(() {
        widget.player?.pause();
        isPlaying = false;
      });
    } else if (widget.player?.isPlaying == null) {
      setState(() {
        widget.player!.open(Audio(widget.currentPlayingSongInfo!.uri));
        widget.player!.play();
        isPlaying = true;
      });
    } else {
      setState(() {
        widget.player?.play();
        isPlaying = true;
      });
    }
  }

  // OnClicked NextSong button method.
  void nextSong() {}

  // OnClicked Shuffle button method.
  void onPressedShuffle() {
    if (widget.player != null) {
      widget.player?.toggleShuffle();
    }
  }

  // Getting enum value of repeat.
  Repeat currentRepeatState = Repeat.repeatOff;

  // OnClicked Repeat button method.
  void onPressedRepeat() {
    if (currentRepeatState == Repeat.repeatOff) {
      setState(() {
        currentRepeatState = Repeat.repeatSingle;
      });
    } else if (currentRepeatState == Repeat.repeatSingle) {
      setState(() {
        currentRepeatState = Repeat.repeatAll;
      });
    } else {
      setState(() {
        currentRepeatState = Repeat.repeatOff;
      });
    }
  }

  // OnChangeSliderValue (Song progress bar) method.
  void onChangedSliderValue(double value) {
    // var player = widget.player;
    // RealtimePlayingInfos infos;
    //
    // int? currentValue = widget.player?.current.value?.audio.duration.inSeconds;
    // setState(() {
    //   sliderValue = value;
    //   if (kDebugMode) {}
    // });
    setState(() {
      sliderValue = value;
    });
  }

  // OnClicked Stop button method TODO:(Probably be removed in production).
  void onPressedStopped() {
    if (widget.player?.isPlaying != null) {
      setState(() {
        widget.player?.stop();
        isPlaying = false;
      });
    }
  }
}
