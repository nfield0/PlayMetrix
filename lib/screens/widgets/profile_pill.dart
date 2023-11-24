import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';

Widget profilePill(String title, String description, Image image) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColours.darkBlue, width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Image.asset("lib/assets/icons/profile_placeholder.png", width: 60),
          const SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.gabarito,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              Text(description)
            ],
          )
        ],
      ));
}

Widget emptyProfile() {
  return Container(
    child: Center(
        child: Column(
      children: [
        Icon(Icons.person_off, size: 50, color: Colors.grey),
        const SizedBox(height: 10),
        Text(
          "No profile(s) found",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    )),
  );
}
