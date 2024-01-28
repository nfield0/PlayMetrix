import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatisticsData {
  final int matchesPlayed;
  final int matchesStarted;
  final int matchesOffTheBench;
  final int totalMinutesPlayed;
  final bool injuryProne;

  StatisticsData(this.matchesPlayed, this.matchesStarted,
      this.matchesOffTheBench, this.totalMinutesPlayed, this.injuryProne);
}

Future<StatisticsData> getStatisticsData(int id) async {
  final apiUrl = '$apiBaseUrl/players/stats/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final parsed = jsonDecode(response.body);

      return StatisticsData(
          parsed["matches_played"],
          parsed["matches_started"],
          parsed["matches_off_the_bench"],
          parsed["minutes_played"],
          parsed["injury_prone"]);
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception('Failed to load player statistics');
}

class StatisticsScreen extends ConsumerWidget {
  AvailabilityData available = AvailabilityData(AvailabilityStatus.Available,
      "Available", Icons.check_circle, AppColours.green);
  AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.Limited, "Limited", Icons.warning, AppColours.yellow);
  AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.Unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            'lib/assets/logo.png',
            width: 150,
            fit: BoxFit.contain,
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 50),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Statistics',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 20),
                      const Text('All Activities',
                          style: TextStyle(
                            fontFamily: AppFonts.gabarito,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      FutureBuilder<StatisticsData>(
                          future: getStatisticsData(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Display a loading indicator while the data is being fetched
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Display an error message if the data fetching fails
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              // Data has been successfully fetched, use it here
                              StatisticsData statistics = snapshot.data!;
                              return Column(
                                children: [
                                  statisticsDetailWithDivider(
                                      "Matches played",
                                      statistics.matchesPlayed.toString(),
                                      available),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  statisticsDetailWithDivider(
                                      "Matches started",
                                      statistics.matchesStarted.toString(),
                                      limited),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  statisticsDetailWithDivider(
                                      "Matches off the bench",
                                      statistics.matchesOffTheBench.toString(),
                                      unavailable),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  statisticsDetailWithDivider(
                                      "Total minutes played",
                                      statistics.totalMinutesPlayed.toString(),
                                      unavailable),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  statisticsDetailWithDivider(
                                      "Injury Prone",
                                      statistics.injuryProne ? "Yes" : "No",
                                      null)
                                ],
                              );
                            } else {
                              return Text('No data available');
                            }
                          }),
                    ]))),
        bottomNavigationBar: playerBottomNavBar(context, 1));
  }
}

Widget statisticsDetailWithDivider(
    String title, String detail, AvailabilityData? availability) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(detail,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 7),
              availability != null
                  ? Icon(availability.icon, color: availability.color, size: 16)
                  : Container(),
            ],
          ),
        ],
      ),
      const SizedBox(height: 10),
      greyDivider(),
    ],
  );
}
