import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

final positionProvider =
    StateProvider<String>((ref) => teamRoleToText(TeamRole.defense));
final availabilityProvider =
    StateProvider<AvailabilityData>((ref) => availabilityData[0]);
final lineupStatusProvider =
    StateProvider<String>((ref) => lineupStatusToText(LineupStatus.starter));

class AddPlayerScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  AddPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);
    String selectedRole = ref.watch(positionProvider);
    AvailabilityData selectedStatus = ref.watch(availabilityProvider);
    String selectedLineupStatus = ref.watch(lineupStatusProvider);

    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Players"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(35),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Player to Team',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const Divider(
                        color: AppColours.darkBlue,
                        thickness: 1.0,
                        height: 40.0,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Enter registered player email:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 25),
                              TextFormField(
                                controller: _emailController,
                                cursorColor: AppColours.darkBlue,
                                decoration: const InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColours.darkBlue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColours.darkBlue),
                                  ),
                                  labelText: 'Email address',
                                  labelStyle: TextStyle(
                                      color: AppColours.darkBlue,
                                      fontFamily: AppFonts.openSans),
                                ),
                                validator: (String? value) {
                                  return (value != null &&
                                          !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                              .hasMatch(value))
                                      ? 'Invalid email format.'
                                      : null;
                                },
                              ),
                              const SizedBox(height: 10),
                              formFieldBottomBorderController(
                                  "Number", _numberController, (value) {
                                if (value != null &&
                                    RegExp(r'^\d+$').hasMatch(value)) {
                                  int numericValue = int.tryParse(value) ?? 0;

                                  if (numericValue > 0 && numericValue < 100) {
                                    return null;
                                  } else {
                                    return "Enter a valid number from 1-99.";
                                  }
                                }

                                return "Enter a valid digit.";
                              }, context),
                              const SizedBox(height: 10),
                              dropdownWithDivider("Position", selectedRole, [
                                teamRoleToText(TeamRole.defense),
                                teamRoleToText(TeamRole.attack),
                                teamRoleToText(TeamRole.midfield),
                                teamRoleToText(TeamRole.goalkeeper),
                              ], (value) {
                                ref.read(positionProvider.notifier).state =
                                    value!;
                              }),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Playing Status",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    DropdownButton<AvailabilityData>(
                                      value: selectedStatus,
                                      items: availabilityData
                                          .map((AvailabilityData item) {
                                        return DropdownMenuItem<
                                            AvailabilityData>(
                                          value: item,
                                          child: Row(
                                            children: [
                                              Icon(item.icon,
                                                  color: item.color),
                                              const SizedBox(width: 8),
                                              Text(
                                                item.message,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        ref
                                            .read(availabilityProvider.notifier)
                                            .state = value!;
                                      },
                                    ),
                                  ]),
                              const SizedBox(height: 10),
                              dropdownWithDivider(
                                  "Lineup Status", selectedLineupStatus, [
                                lineupStatusToText(LineupStatus.starter),
                                lineupStatusToText(LineupStatus.substitute),
                                lineupStatusToText(LineupStatus.reserve)
                              ], (value) {
                                ref.read(lineupStatusProvider.notifier).state =
                                    value!;
                              }),
                              const SizedBox(height: 40),
                              bigButton("Add Player", () async {
                                if (_formKey.currentState!.validate()) {
                                  int playerId = await findPlayerIdByEmail(
                                      _emailController.text);

                                  if (playerId != -1) {
                                    await addTeamPlayer(
                                        ref.read(teamIdProvider.notifier).state,
                                        playerId,
                                        ref
                                            .read(positionProvider.notifier)
                                            .state,
                                        int.parse(_numberController.text),
                                        selectedStatus,
                                        ref.read(lineupStatusProvider));
                                    ref.read(positionProvider.notifier).state =
                                        teamRoleToText(TeamRole.defense);
                                    ref
                                        .read(availabilityProvider.notifier)
                                        .state = availabilityData[0];
                                    navigator.push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayersScreen()),
                                    );
                                  } else {
                                    showPlayerNotFoundDialog(context);
                                  }
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}

void showPlayerNotFoundDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Player Not Found',
            style: TextStyle(
                color: AppColours.darkBlue,
                fontFamily: AppFonts.gabarito,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        content: const Text(
            'Sorry, player with that email does not exist. Please enter a different email address and try again.',
            style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
