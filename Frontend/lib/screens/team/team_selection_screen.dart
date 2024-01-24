import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/player_profile_set_up_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


final positionProvider = StateProvider<String>((ref) => "Defense");

Future<void> addTeamPlayer(int teamId, int userId, String teamPosition) async {
  final apiUrl = 'http://127.0.0.1:8000/team_player';
  print(teamId);
  print(userId);
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "team_id": teamId,
        "player_id": userId,
        "team_position": teamPosition,
        "player_team_number": 0,
        "playing_status": "",
        "lineup_status": ""
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added data to the backend
      print("Successfully added player to team");
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to add data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<void> addTeamPhysio(int teamId, int userId) async {
  final apiUrl = 'http://127.0.0.1:8000/team_physio';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, dynamic>{"team_id": teamId, "physio_id": userId}),
    );

    if (response.statusCode == 200) {
      // Successfully added data to the backend
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to add data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<void> addTeamCoach(int teamId, int userId, String role) async {
  final apiUrl = 'http://127.0.0.1:8000/team_coach';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "team_id": teamId,
        "coach_id": userId,
        "team_role": role
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added data to the backend
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to add data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

// class TeamSelectionScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     int selectedTeamId = ref.watch(teamIdProvider);
//     final userRole = ref.watch(userRoleProvider.notifier).state;

//     final teamRoles = [
//       TeamRole.defense,
//       TeamRole.attack,
//       TeamRole.midfield,
//       TeamRole.goalkeeper,
//       TeamRole.headCoach
//     ];
//     String selectedRole = ref.watch(positionProvider);

//     final teamPositions = [
//       TeamRole.defense,
//       TeamRole.attack,
//       TeamRole.midfield,
//       TeamRole.goalkeeper,
//     ];

//     int userId = ref.watch(userIdProvider.notifier).state;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Image.asset(
//           'lib/assets/logo.png',
//           width: 150,
//           fit: BoxFit.contain,
//         ),
//         iconTheme: const IconThemeData(
//           color: AppColours.darkBlue, //change your color here
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//           child: Container(
//               padding: const EdgeInsets.all(35),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Select Your Team',
//                         style: TextStyle(
//                           color: AppColours.darkBlue,
//                           fontFamily: AppFonts.gabarito,
//                           fontSize: 36.0,
//                           fontWeight: FontWeight.w700,
//                         )),
//                     const SizedBox(height: 10),
//                     divider(),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Form(
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(children: [
//                               const SizedBox(height: 50),
//                               Center(
//                                 child: Column(children: [
//                                   const Text(
//                                     "What team are you on?",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   const SizedBox(height: 15),
//                                   FutureBuilder<List<TeamData>>(
//                                     future: getAllTeams(),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.hasData) {
//                                         List<TeamData> teams = snapshot.data!;
//                                         // Initialize the selectedTeam with the first team name
//                                         if (selectedTeamId == 0 &&
//                                             teams.isNotEmpty) {
//                                           selectedTeamId = teams[0].team_id;
//                                           Future.delayed(Duration.zero, () {
//                                             ref
//                                                 .read(teamIdProvider.notifier)
//                                                 .state = selectedTeamId;
//                                           });
//                                         }

//                                         return DropdownButton<int>(
//                                           value: selectedTeamId,
//                                           items: teams.map((TeamData team) {
//                                             return DropdownMenuItem<int>(
//                                               value: team.team_id,
//                                               child: Text(
//                                                 team.team_name,
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                 ),
//                                               ),
//                                             );
//                                           }).toList(),
//                                           onChanged: (value) {
//                                             // Update the selectedTeam when the user makes a selection
//                                             ref
//                                                 .read(teamIdProvider.notifier)
//                                                 .state = value!;
//                                           },
//                                         );
//                                       } else if (snapshot.hasError) {
//                                         return Text("Error loading teams");
//                                       } else {
//                                         return CircularProgressIndicator();
//                                       }
//                                     },
//                                   ),
//                                   if (userRole == UserRole.coach)
//                                     Column(children: [
//                                       const SizedBox(height: 35),
//                                       const Text(
//                                         "What is your role?",
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(height: 15),
//                                       DropdownButton<String>(
//                                         value: selectedRole,
//                                         items: teamRoles.map((TeamRole role) {
//                                           return DropdownMenuItem<String>(
//                                             value: teamRoleToText(role),
//                                             child: Text(
//                                               teamRoleToText(role),
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) {
//                                           // Update the selectedTeam when the user makes a selection
//                                           ref
//                                               .read(positionProvider.notifier)
//                                               .state = value!;
//                                         },
//                                       )
//                                     ]),
//                                   if (userRole == UserRole.player)
//                                     Column(children: [
//                                       const SizedBox(height: 35),
//                                       const Text(
//                                         "What position do you play?",
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(height: 15),
//                                       DropdownButton<String>(
//                                         value: selectedRole,
//                                         items:
//                                             teamPositions.map((TeamRole role) {
//                                           return DropdownMenuItem<String>(
//                                             value: teamRoleToText(role),
//                                             child: Text(
//                                               teamRoleToText(role),
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) {
//                                           ref
//                                               .read(positionProvider.notifier)
//                                               .state = value!;
//                                         },
//                                       )
//                                     ])
//                                 ]),
//                               ),
//                             ]),
//                             const SizedBox(height: 50),
//                             bigButton("Save Changes", () {
//                               if (userRole == UserRole.physio) {
//                                 addTeamPhysio(selectedTeamId, userId);
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             ProfileSetUpScreen()));
//                               } else if (userRole == UserRole.player) {
//                                 addTeamPlayer(
//                                     selectedTeamId, userId, selectedRole);
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             PlayerProfileSetUpScreen()));
//                               } else if (userRole == UserRole.coach) {
//                                 addTeamCoach(
//                                     selectedTeamId, userId, selectedRole);
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             ProfileSetUpScreen()));
//                               }
//                             })
//                           ]),
//                     )
//                   ]))),
//     );
//   }
// }
