import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class StatisticsScreen extends ConsumerWidget {
  final AvailabilityData available = AvailabilityData(
      AvailabilityStatus.available,
      "Available",
      Icons.check_circle,
      AppColours.green);
  final AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.limited, "Limited", Icons.warning, AppColours.yellow);
  final AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
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
                padding: const EdgeInsets.only(top: 20, right: 35, left: 35),
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
                              return statisticsSection(
                                  statistics, available, limited, unavailable);
                            } else {
                              return Text('No data available');
                            }
                          }),
                    ]))),
        bottomNavigationBar: playerBottomNavBar(context, 0));
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
