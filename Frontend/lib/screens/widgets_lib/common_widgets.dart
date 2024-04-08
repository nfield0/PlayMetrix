import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_metrix/constants.dart';

Widget smallPill(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
    decoration: BoxDecoration(
      color: AppColours.darkBlue,
      borderRadius: BorderRadius.circular(50),
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

Widget filePill(
    String title, String description, IconData icon, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.black26, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 45),
          const SizedBox(width: 20),
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

Widget profilePill(String title, String description, String imagePath,
    Uint8List? imageBytes, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColours.darkBlue, width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageBytes != null && imageBytes.isNotEmpty
              ? ClipRRect(
                  borderRadius:
                      BorderRadius.circular(75), // Adjust the radius as needed
                  child: Image.memory(
                    imageBytes,
                    width: 65,
                    height: 65,
                    fit: BoxFit
                        .cover, // Ensure the image fills the rounded rectangle
                  ),
                )
              : Image.asset(imagePath, width: 65),
          const SizedBox(width: 20),
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
      const SizedBox(height: 10),
    ],
  ));
}

Widget divider() {
  return const Divider(
    color: AppColours.darkBlue,
    thickness: 1,
  );
}

Widget greyDivider() {
  return const Divider(
    color: AppColours.grey,
    thickness: 1,
  );
}

Widget greyDividerThick() {
  return const Divider(
    color: Colors.black12,
    thickness: 2.5,
  );
}

Widget detailWithDivider(String title, String detail, BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 >= 800 * 0.5
                ? 800 * 0.5
                : MediaQuery.of(context).size.width * 0.5,
            child: Text(detail,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          )
        ],
      ),
      const SizedBox(height: 10),
      greyDivider(),
    ],
  );
}

Widget detailWithDividerSmall(
    String title, String detail, BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4 >= 800 * 0.4
                ? 800 * 0.4
                : MediaQuery.of(context).size.width * 0.4,
            child: Text(detail,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          )
        ],
      ),
      const SizedBox(height: 10),
      greyDivider(),
    ],
  );
}

Widget detailBoldTitle(String title, String detail) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(detail, style: const TextStyle(fontSize: 16)),
        ],
      ),
      const SizedBox(height: 10),
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

Widget datePickerNoDivider(BuildContext context, String title,
    DateTime selectedDate, void Function(DateTime) onChanged) {
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
              // Show date picker
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(1920),
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
    ],
  );
}

Widget datePickerNoDividerTooltip(
    BuildContext context,
    String title,
    DateTime selectedDate,
    void Function(DateTime) onChanged,
    String tooltipMessage) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            Tooltip(
                message: tooltipMessage,
                child: const Icon(Icons.info_outline,
                    size: 20, color: Colors.grey)),
          ]),
          TextButton(
            onPressed: () async {
              // Show date picker
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(1920),
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

Widget formFieldBottomBorderController(
    String title,
    TextEditingController controller,
    String? Function(String?)? validator,
    BuildContext context) {
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
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.4 >= 800 * 0.4
            ? 800 * 0.4
            : MediaQuery.of(context).size.width * 0.4,
        child: TextFormField(
          controller: controller,
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
          validator: validator,
        ),
      ),
    ],
  );
}

Widget formFieldBottomBorderNoTitle(
    String title,
    String initialValue,
    bool showBorder,
    TextEditingController controller,
    String? Function(String?)? validator) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: TextFormField(
          controller: controller,
          maxLines: null,
          validator: validator,
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
          fontSize: 24,
          fontFamily: AppFonts.gabarito,
        ))
  ]);
}

Widget announcementBox({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String description,
  required String date,
}) {
  return InkWell(
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
                          Text(
                              DateFormat('d MMMM y HH:mm').format(
                                  date.isNotEmpty
                                      ? DateTime.parse(date)
                                      : DateTime.now()),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          // const SizedBox(height: 5),
                          Text(
                            description,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )));
}
