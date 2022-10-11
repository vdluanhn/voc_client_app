import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/models/Team.dart';

import '../../modules/login/view_model/user_vm.dart';
import 'iteam_service.dart';

class TeamService implements IteamService {
  @override
  Future<Team?> findTeamByCard(BuildContext context, String cardNumber) async {
    var userVM = Provider.of<UserVM>(context, listen: false);
    var lst = userVM.teams.where((element) => element.cardNumber == cardNumber).toList();
    if (lst.isNotEmpty) return lst[0];
    return null;
  }
}
