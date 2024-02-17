class Notification {
  final String title;
  final String desc;
  final DateTime date;
  final int teamId;
  final int posterId;
  final String posterType;

  Notification(
      {required this.title,
      required this.desc,
      required this.date,
      required this.teamId,
      required this.posterId,
      required this.posterType});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['notification_title'],
      desc: json['notification_desc'],
      date: json['notification_date'],
      teamId: json['team_id'],
      posterId: json['poster_id'],
      posterType: json['poster_type'],
    );
  }
}
