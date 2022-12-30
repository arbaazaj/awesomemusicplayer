import 'package:awesomemusicplayer/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlowingIcon extends StatelessWidget {
  const GlowingIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
          color: Colors.transparent,
          boxShadow: [
            // BoxShadow(
            //   color: lightCream,
            //   spreadRadius: 1,
            //   blurRadius: 20,
            // ),
            BoxShadow(
              color: lightCream,
              spreadRadius: -6,
              blurRadius: 10,
            )
          ]),
      child: const Icon(CupertinoIcons.repeat, color: lightCream),
    );
  }
}
