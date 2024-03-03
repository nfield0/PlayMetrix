import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_metrix/api_clients/coach_api_client.dart';
import 'package:play_metrix/api_clients/manager_api_client.dart';
import 'package:play_metrix/api_clients/physio_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

Future<void> updateProfile(UserRole userRole, int id, String firstName,
    String surname, String contactNumber, Uint8List image) async {
  if (userRole == UserRole.manager) {
    return updateManagerProfile(
        id, ProfileName(firstName, surname), contactNumber, image);
  } else if (userRole == UserRole.physio) {
    return updatePhysioProfile(
        id, ProfileName(firstName, surname), contactNumber, image);
  } else if (userRole == UserRole.coach) {
    return updateCoachProfile(
        id, ProfileName(firstName, surname), contactNumber, image);
  }

  throw Exception("Profile not found");
}

class EditProfileScreen extends StatefulWidget {
  final int userId;
  final UserRole userRole;

  const EditProfileScreen(
      {super.key, required this.userId, required this.userRole});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneRegex = RegExp(r'^(?:\+\d{1,3}\s?)?\d{9,15}$');
  final nameRegex = RegExp(r'^[A-Za-z]+$');

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Uint8List? _profilePicture;

  @override
  void initState() {
    super.initState();
    getProfileDetails(widget.userId, widget.userRole).then((profile) {
      setState(() {
        firstNameController.text = profile.firstName;
        surnameController.text = profile.surname;
        phoneController.text = profile.contactNumber;
        _profilePicture = profile.imageBytes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        setState(() {
          _profilePicture = Uint8List.fromList(imageBytes);
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              fontFamily: AppFonts.gabarito,
              color: AppColours.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 35, right: 35, left: 35),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                  child: Column(children: [
                                _profilePicture != null &&
                                        _profilePicture!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(75),
                                        child: Image.memory(
                                          _profilePicture!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        "lib/assets/icons/profile_placeholder.png",
                                        width: 120,
                                      ),
                                const SizedBox(height: 10),
                                underlineButtonTransparent("Edit picture", () {
                                  pickImage();
                                }),
                              ])),
                              const SizedBox(height: 30),
                              formFieldBottomBorderController(
                                  "First name", firstNameController,
                                  (String? value) {
                                return (value != null &&
                                        !nameRegex.hasMatch(value))
                                    ? 'Invalid first name.'
                                    : null;
                              }, context),
                              formFieldBottomBorderController(
                                  "Surname", surnameController,
                                  (String? value) {
                                return (value != null &&
                                        !nameRegex.hasMatch(value))
                                    ? 'Invalid surname.'
                                    : null;
                              }, context),
                              formFieldBottomBorderController(
                                  "Phone", phoneController, (String? value) {
                                return (value != null &&
                                        !phoneRegex.hasMatch(value))
                                    ? 'Invalid phone number.'
                                    : null;
                              }, context),
                              const SizedBox(height: 40),
                              bigButton("Save Changes", () {
                                if (_formKey.currentState!.validate()) {
                                  updateProfile(
                                          widget.userRole,
                                          widget.userId,
                                          firstNameController.text,
                                          surnameController.text,
                                          phoneController.text,
                                          _profilePicture ?? Uint8List(0))
                                      .then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileScreen()),
                                    );
                                  });
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar:
            roleBasedBottomNavBar(widget.userRole, context, 2));
  }
}
