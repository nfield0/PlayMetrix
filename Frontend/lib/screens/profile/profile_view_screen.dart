import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/coach_api_client.dart';
import 'package:play_metrix/data_models/coach_data_model.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';

class ProfileViewScreen extends ConsumerWidget {
  final int userId;
  final UserRole userRole;

  const ProfileViewScreen(
      {super.key, required this.userId, required this.userRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (userRole != UserRole.coach) {
      return FutureBuilder<Profile>(
          future: getProfileDetails(userId, userRole),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              Profile profile = snapshot.data!;

              return profileDetails(
                  profile, context, ref, userId, userRole, "");
            } else {
              return const Text('No data available');
            }
          });
    } else {
      return FutureBuilder<CoachData>(
          future: getCoachDataProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              CoachData coachData = snapshot.data!;

              return profileDetails(coachData.profile, context, ref, userId,
                  userRole, coachTeamRoleToText(coachData.role));
            } else {
              return const Text('No data available');
            }
          });
    }
  }
}
