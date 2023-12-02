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
      style: const TextStyle(
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
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.gabarito,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(description),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget emptySection(IconData icon, String text) {
  return Center(
      child: Column(
    children: [
      Icon(icon, size: 50, color: Colors.grey),
      const SizedBox(height: 10),
      Text(
        text,
        style: const TextStyle(
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

Widget dropdownWithDivider(String title, String selectedValue,
    List<String> dropdownItems, void Function(String?) onChanged) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          DropdownButton<String>(
            value: selectedValue,
            items: dropdownItems.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    ],
  );
}

Widget dateTimePickerWithDivider(BuildContext context, String title,
    DateTime selectedDateTime, void Function(DateTime) onChanged) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () async {
              // Show date picker
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDateTime,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                // Show time picker if date is selected
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                );

                if (pickedTime != null) {
                  // Combine date and time
                  final DateTime pickedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  // Call the onChanged callback with the selected date and time
                  onChanged(pickedDateTime);
                }
              }
            },
            child: Text(
              "${selectedDateTime.toLocal()}"
                  .split('.')[0], // Display selected date and time
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
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
          decoration: const InputDecoration(
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

Widget formFieldBottomBorderNoTitle(
    String title, String initialValue, bool showBorder) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: TextField(
          controller: TextEditingController(text: initialValue),
          decoration: InputDecoration(
            // labelText: 'Your Label',
            hintText: title,
            hintStyle: const TextStyle(color: Colors.black38),
            focusedBorder: showBorder
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColours.grey),
                  )
                : InputBorder.none,
            enabledBorder: showBorder
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColours.grey),
                  )
                : InputBorder.none,
          ),
        ),
      ),
    ],
  );
}

Widget appBarTitlePreviousPage(String text) {
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(text,
        style: const TextStyle(
          color: AppColours.darkBlue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ))
  ]);
}
