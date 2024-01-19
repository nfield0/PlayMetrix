import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';

Widget smallButton(IconData icon, String text, VoidCallback onPressed) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColours.darkBlue, width: 2),
      borderRadius: BorderRadius.circular(50),
    ),
    child: CupertinoButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      borderRadius: BorderRadius.circular(50),
      color: CupertinoColors.white,
      minSize: 0,
      pressedOpacity: 0.8, // Adjust the opacity when the button is pressed
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColours.darkBlue,
            size: 16,
          ),
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

Widget bigButton(String text, VoidCallback onPressed) {
  return CupertinoButton(
    onPressed: onPressed,
    borderRadius: BorderRadius.circular(30),
    color: AppColours.darkBlue,
    child: SizedBox(
      width: double.infinity, // Set width to infinity to take up the full width
      child: Center(
        child: Text(text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.openSans,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            )),
      ),
    ),
  );
}

Widget underlineButtonTransparent(String text, VoidCallback onPressed) {
  return CupertinoButton(
    onPressed: onPressed,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColours.darkBlue,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontFamily: AppFonts.gabarito,
          fontSize: 20,
        ),
      ),
    ),
  );
}
