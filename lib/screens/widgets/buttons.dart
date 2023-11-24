import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';

Widget smallButton(Icon icon, String text) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColours.darkBlue, width: 3),
      borderRadius: BorderRadius.circular(50),
    ),
    child: CupertinoButton(
      onPressed: () {
        // Add your onPressed logic here
      },
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      borderRadius: BorderRadius.circular(50),
      color: CupertinoColors.white,
      minSize: 0,
      pressedOpacity: 0.8, // Adjust the opacity when the button is pressed
      child: Row(
        children: [
          icon,
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: AppColours.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
