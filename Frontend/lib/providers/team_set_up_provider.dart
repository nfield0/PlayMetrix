import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamIdProvider = StateProvider<int>((ref) => -1);
final leagueProvider = StateProvider<int>((ref) => 0);
final teamLogoProvider = StateProvider<Uint8List?>((ref) => null);