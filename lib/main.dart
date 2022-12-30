// @dart=2.9

import 'package:awesomemusicplayer/screens/account.dart';
import 'package:awesomemusicplayer/screens/homepage.dart';
import 'package:awesomemusicplayer/themes/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awesome Music Player',
      theme: ThemeData(
          primarySwatch: Colors.orange, colorScheme: const ColorScheme.dark()),
      home: Scaffold(
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          backgroundColor: lightPink,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () => onPressedAccount(context),
                icon: const Icon(Icons.account_circle,
                    color: lightCream, size: 36),
              ),
            )
          ],
          title: const Text('Awesome Music Player',
              style: TextStyle(color: lightCream, fontSize: 24)),
        ),
        body: const MyHomePage(),
      ),
    );
  }

  void onPressedAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Account()),
    );
  }
}
