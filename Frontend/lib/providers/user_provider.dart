import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/enums.dart';

final userIdProvider = StateProvider<int>((ref) => 0);

final userRoleProvider = StateProvider<UserRole>((ref) => UserRole.manager);

final teamRoleProvider =
    StateProvider<String>((ref) => teamRoleToText(TeamRole.headCoach));
