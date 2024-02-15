// UswrRole

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