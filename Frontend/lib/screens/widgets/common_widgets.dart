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
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: selectedValue,
            items: dropdownItems.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item,
                    style: const TextStyle(
                      fontSize: 16,
                    )),
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
          Text(title, style: const TextStyle(fontSize: 16)),
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
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget datePickerWithDivider(BuildContext context, String title,
    DateTime selectedDate, void Function(DateTime) onChanged) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          TextButton(
            onPressed: () async {
              // Show date picker
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                // Call the onChanged callback with the selected date
                onChanged(pickedDate);
              }
            },
            child: Text(
              "${selectedDate.toLocal().toLocal()}"
                  .split(' ')[0], // Display selected date
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      greyDivider()
    ],
  );
}

Widget timePickerWithDivider(BuildContext context, String title,
    TimeOfDay selectedTime, void Function(TimeOfDay) onChanged) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () async {
              // Show time picker
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );

              if (pickedTime != null) {
                // Call the onChanged callback with the selected time
                onChanged(pickedTime);
              }
            },
            child: Text(
              "${selectedTime.format(context)}", // Display selected time
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      greyDivider()
    ],
  );
}

Widget formFieldBottomBorder(String title, String initialValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
      const SizedBox(width: 30),
      Container(
        width: 210, // Set a fixed width for the TextField
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
          maxLines: null,
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

Widget announcementBox({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String description,
  required String date,
  required VoidCallback onDeletePressed,
  required VoidCallback onBoxPressed,
}) {
  return InkWell(
      onTap: onBoxPressed,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColours.darkBlue,
                      width: 2,
                    ), // Border color
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  constraints: const BoxConstraints(
                    minHeight: 70, // Set your desired minHeight
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      // Icon on top left
                      // Title and description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(description),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: onDeletePressed,
                          child: const Icon(
                            Icons.delete,
                            size: 20,
                            color: AppColours.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )));
}
