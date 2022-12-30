import 'package:flutter/material.dart';
import 'package:awesomemusicplayer/themes/colors.dart';

class CustomSearchBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomSearchBar({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
              child: Expanded(
                child: TextField(

                  style: const TextStyle(color: lightPink, fontSize: 18),
                  cursorColor: darkBlue,
                  cursorHeight: 25,
                  decoration: InputDecoration(
                    fillColor: lightBlue,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16.0)),
                    suffixIcon: const Icon(Icons.search_sharp, color: darkBlue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
