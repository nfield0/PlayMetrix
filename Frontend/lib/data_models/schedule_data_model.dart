class Schedule {
  int schedule_id;
  String schedule_title;
  String schedule_location;
  String schedule_type;
  String schedule_start_time;
  String schedule_end_time;
  String schedule_alert_time;

  Schedule(
      {required this.schedule_id,
      required this.schedule_title,
      required this.schedule_location,
      required this.schedule_type,
      required this.schedule_start_time,
      required this.schedule_end_time,
      required this.schedule_alert_time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        schedule_id: json['schedule_id'],
        schedule_title: json['schedule_title'],
        schedule_location: json['schedule_location'],
        schedule_type: json['schedule_type'],
        schedule_start_time: json['schedule_start_time'],
        schedule_end_time: json['schedule_end_time'],
        schedule_alert_time: json['schedule_alert_time']);
  }
}
