// UserRole

enum UserRole {
  manager,
  coach,
  player,
  physio,
}

String userRoleText(UserRole userRole) {
  switch (userRole) {
    case UserRole.manager:
      return "Manager";
    case UserRole.player:
      return "Player";
    case UserRole.coach:
      return "Coach";
    case UserRole.physio:
      return "Physio";
  }
}

UserRole stringToUserRole(String userRole) {
  switch (userRole) {
    case "manager":
      return UserRole.manager;
    case "player":
      return UserRole.player;
    case "coach":
      return UserRole.coach;
    case "physio":
      return UserRole.physio;
    default:
      return UserRole.manager;
  }
}

// Lineup Status

enum LineupStatus { starter, substitute, reserve }

String lineupStatusToText(LineupStatus status) {
  switch (status) {
    case LineupStatus.starter:
      return "Starter";
    case LineupStatus.substitute:
      return "Substitute";
    case LineupStatus.reserve:
      return "Reserve";
  }
}

LineupStatus textToLineupStatus(String text) {
  switch (text) {
    case "Starter":
      return LineupStatus.starter;
    case "Substitute":
      return LineupStatus.substitute;
    case "Reserve":
      return LineupStatus.reserve;
    default:
      return LineupStatus.starter;
  }
}

// Availability Status

enum AvailabilityStatus { available, limited, unavailable }

String availabilityStatusText(AvailabilityStatus status) {
  switch (status) {
    case AvailabilityStatus.available:
      return "Available";
    case AvailabilityStatus.limited:
      return "Limited";
    case AvailabilityStatus.unavailable:
      return "Unavailable";
  }
}

AvailabilityStatus stringToAvailabilityStatus(String status) {
  switch (status) {
    case "Available":
      return AvailabilityStatus.available;
    case "Unavailable":
      return AvailabilityStatus.unavailable;
    case "Limited":
      return AvailabilityStatus.limited;
  }
  return AvailabilityStatus.available;
}

// Alert Time

enum AlertTime {
  none,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  twoHours,
  oneDay,
  twoDays,
}

String alertTimeToText(AlertTime alertTime) {
  switch (alertTime) {
    case AlertTime.none:
      return "None";
    case AlertTime.fifteenMinutes:
      return "15 minutes before";
    case AlertTime.thirtyMinutes:
      return "30 minutes before";
    case AlertTime.oneHour:
      return "1 hour before";
    case AlertTime.twoHours:
      return "2 hours before";
    case AlertTime.oneDay:
      return "1 day before";
    case AlertTime.twoDays:
      return "2 days before";
  }
}

AlertTime textToAlertTime(String text) {
  switch (text) {
    case "None":
      return AlertTime.none;
    case "15 minutes before":
      return AlertTime.fifteenMinutes;
    case "30 minutes before":
      return AlertTime.thirtyMinutes;
    case "1 hour before":
      return AlertTime.oneHour;
    case "2 hours before":
      return AlertTime.twoHours;
    case "1 day before":
      return AlertTime.oneDay;
    case "2 days before":
      return AlertTime.twoDays;
  }
  return AlertTime.none;
}

// Schedule Type

enum ScheduleType {
  training,
  match,
  meeting,
  other,
}

ScheduleType textToScheduleType(String text) {
  switch (text) {
    case "Training":
      return ScheduleType.training;
    case "Match":
      return ScheduleType.match;
    case "Meeting":
      return ScheduleType.meeting;
    case "Other":
      return ScheduleType.other;
  }
  return ScheduleType.other;
}

String scheduleTypeToText(ScheduleType scheduleType) {
  switch (scheduleType) {
    case ScheduleType.training:
      return "Training";
    case ScheduleType.match:
      return "Match";
    case ScheduleType.meeting:
      return "Meeting";
    case ScheduleType.other:
      return "Other";
  }
}

// Player Attending Status

enum PlayerAttendingStatus { present, absent, undecided }

String playerAttendingStatusToString(PlayerAttendingStatus status) {
  switch (status) {
    case PlayerAttendingStatus.present:
      return "Yes";
    case PlayerAttendingStatus.absent:
      return "No";
    case PlayerAttendingStatus.undecided:
      return "Unknown";
  }
}

PlayerAttendingStatus stringToPlayerAttendingStatus(String status) {
  switch (status) {
    case "Yes":
      return PlayerAttendingStatus.present;
    case "No":
      return PlayerAttendingStatus.absent;
    case "Unknown":
      return PlayerAttendingStatus.undecided;
    default:
      return PlayerAttendingStatus.undecided;
  }
}

// Team Role

enum TeamRole { defense, attack, midfield, goalkeeper, headCoach }

String teamRoleToText(TeamRole role) {
  switch (role) {
    case TeamRole.defense:
      return 'Defense';
    case TeamRole.attack:
      return 'Attack';
    case TeamRole.midfield:
      return 'Midfield';
    case TeamRole.goalkeeper:
      return 'Goalkeeper';
    case TeamRole.headCoach:
      return 'Head Coach';
  }
}