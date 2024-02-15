import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';

class ProfilePictureSignUpScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  ProfilePictureSignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        ref.read(profilePictureProvider.notifier).state =
            Uint8List.fromList(imageBytes);
      }
    }

    Uint8List? profilePicture = ref.watch(profilePictureProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          'lib/assets/logo_white.png',
          width: 150,
          fit: BoxFit.contain,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/signup_page_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 50),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Step 5/5',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Choose a profile picture',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.gabarito,
                              fontSize: 36.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Center(
                              child: Column(children: [
                            profilePicture != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(75),
                                    child: Image.memory(
                                      profilePicture,
                                      width: 135,
                                      height: 135,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    "lib/assets/icons/profile_placeholder.png",
                                    width: 135,
                                  ),
                            const SizedBox(height: 10),
                            profilePicture == null
                                ? underlineButtonTransparentBlack(
                                    "Upload picture", () {
                                    pickImage();
                                  })
                                : underlineButtonTransparentRed(
                                    "Remove picture", () {
                                    profilePicture = null;
                                    ref
                                        .read(profilePictureProvider.notifier)
                                        .state = null;
                                  })
                          ])),
                          const SizedBox(height: 30),
                          Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: bigButton(
                                  profilePicture == null ? "Skip" : "Next",
                                  () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SignUpChooseTypeScreen(),
                                    ),
                                  );
                                }
                              })),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
