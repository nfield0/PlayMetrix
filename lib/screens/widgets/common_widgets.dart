import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';

Widget smallPill(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
    decoration: BoxDecoration(
      color: AppColours.darkBlue,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
}

Widget profilePill(String title, String description, String imagePath,
    VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColours.darkBlue, width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 60),
          const SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
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
      ),
    ),
  );
}

Widget emptyProfile() {
  return const Center(
      child: Column(
    children: [
      Icon(Icons.person_off, size: 50, color: Colors.grey),
      SizedBox(height: 10),
      Text(
        "No profile(s) found",
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ],
  ));
}

Widget divider() {
  return const Divider(
    color: AppColours.darkBlue, // You can set the color of the divider
    thickness: 1, // You can set the thickness of the divider
  );
}

Widget greyDivider() {
  return const Divider(
    color: AppColours.grey, // You can set the color of the divider
    thickness: 1, // You can set the thickness of the divider
  );
}

Widget detailWithDivider(String title, String detail) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(detail,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      const SizedBox(height: 10),
      greyDivider(),
    ],
  );
}

Widget formFieldBottomBorder(String title, String initialValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(width: 30),
      Container(
        width: 220, // Set a fixed width for the TextField
        child: TextField(
          controller: TextEditingController(text: initialValue),
          decoration: InputDecoration(
            // labelText: 'Your Label',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    ],
  );
}
