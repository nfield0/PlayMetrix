import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:play_metrix/api_clients/schedule_api_client.dart';
import 'package:play_metrix/data_models/schedule_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initialiseNotifications() async {
  WidgetsFlutterBinding.ensureInitialized();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

DateTime calculateScheduleAlertTime(DateTime startTime, AlertTime alertTime) {
  switch (alertTime) {
    case AlertTime.none:
      return startTime;
    case AlertTime.fifteenMinutes:
      return startTime.subtract(const Duration(minutes: 15));
    case AlertTime.thirtyMinutes:
      return startTime.subtract(const Duration(minutes: 30));
    case AlertTime.oneHour:
      return startTime.subtract(const Duration(hours: 1));
    case AlertTime.twoHours:
      return startTime.subtract(const Duration(hours: 2));
    case AlertTime.oneDay:
      return startTime.subtract(const Duration(days: 1));
    case AlertTime.twoDays:
      return startTime.subtract(const Duration(days: 2));
  }
}

Future<void> configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

const scheduleChannelId = 'Schedule Channel Id';
const scheduleChannelName = 'Schedule Channel';
const scheduleChannelDescription = 'Channel for schedule notifications';

String formatDateTimeRange(String startISOTimeString, String endISOTimeString) {
  final DateFormat dateFormatter = DateFormat.MMMMd();
  final DateFormat timeFormatter = DateFormat.jm();

  final DateTime startDateTime = DateTime.parse(startISOTimeString);
  final DateTime endDateTime = DateTime.parse(endISOTimeString);

  final String formattedDate = dateFormatter.format(startDateTime);
  final String formattedStartTime = timeFormatter.format(startDateTime);
  final String formattedEndTime = timeFormatter.format(endDateTime);

  return '$formattedDate, $formattedStartTime-$formattedEndTime';
}

Future<void> scheduleNotificationsForTeamSchedules(int teamId) async {
  final List<Schedule> schedules = await getTeamSchedules(teamId);

  // Cancel existing notifications for the team's schedules
  await flutterLocalNotificationsPlugin.cancelAll();

  // Schedule notifications for each schedule
  for (final schedule in schedules) {
    final DateTime startTime = DateTime.parse(schedule.schedule_start_time);
    final DateTime alertTime = calculateScheduleAlertTime(
      startTime,
      textToAlertTime(schedule.schedule_alert_time),
    );

    // Schedule notification if it's in the future
    if (alertTime.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        schedule.schedule_id,
        schedule.schedule_title,
        formatDateTimeRange(
            schedule.schedule_start_time, schedule.schedule_end_time),
        tz.TZDateTime.from(alertTime, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                scheduleChannelId, scheduleChannelName,
                channelDescription: scheduleChannelDescription)),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }
}
