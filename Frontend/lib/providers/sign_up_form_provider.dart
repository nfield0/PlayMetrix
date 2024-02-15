import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firstNameProvider = StateProvider<String>((ref) => "");
final surnameProvider = StateProvider<String>((ref) => "");

final emailProvider = StateProvider<String>((ref) => "");

final phoneProvider = StateProvider<String>((ref) => "");
final verificationCodeProvider = StateProvider<String>((ref) => "");

final passwordProvider = StateProvider<String>((ref) => "");
final passwordVisibilityNotifier = StateProvider<bool>((ref) => true);
final confirmPasswordVisibilityNotifier = StateProvider<bool>((ref) => true);

final profilePictureProvider = StateProvider<Uint8List?>((ref) => null);

void clearSignUpForm(WidgetRef ref) {
  ref.read(firstNameProvider.notifier).state = "";
  ref.read(surnameProvider.notifier).state = "";
  ref.read(emailProvider.notifier).state = "";
  ref.read(phoneProvider.notifier).state = "";
  ref.read(passwordProvider.notifier).state = "";
  ref.read(verificationCodeProvider.notifier).state = "";
  ref.read(profilePictureProvider.notifier).state = null;
  ref.read(passwordVisibilityNotifier.notifier).state = true;
  ref.read(confirmPasswordVisibilityNotifier.notifier).state = true;
}
