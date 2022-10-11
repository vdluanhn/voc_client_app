import 'package:flutter/material.dart';

import '../../models/Team.dart';

abstract class IteamService {
  Future<Team?> findTeamByCard(BuildContext context, String cardNumber);
}
