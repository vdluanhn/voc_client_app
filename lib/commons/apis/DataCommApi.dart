import 'package:provider/provider.dart';

import '../../modules/login/view_model/user_vm.dart';
import 'common/BaseApi.dart';

class DataCommApi extends BaseApi {
  Future getRacingLevels(
    context,
  ) async {
    var response = await httpRequest.sendGet(
      uri: getUri('/api/ref/racing-levels', useBaseUrl: false),
    );
    return validateResponse(response);
  }

  Future getRacingTypes(
    context,
  ) async {
    var response = await httpRequest.sendGet(
      uri: getUri('/api/ref/racing-types', useBaseUrl: false),
    );
    return validateResponse(response);
  }

  Future getTeamsByLevel(context, String level) async {
    level = level.toUpperCase();
    // String token = await LocalStorageService.readItem("Authorization");

    UserVM userVm = Provider.of<UserVM>(context, listen: false);
    String? token = userVm.user?.accessToken;
    var response = await httpRequest.sendGet(uri: getUri('/api/teams/level/$level', useBaseUrl: false), token: token);
    return validateResponse(response);
  }
}
