import 'package:voc_client_app/models/RacingLevel.dart';
import 'package:voc_client_app/models/RacingType.dart';

class ComboData {
  final String id;
  final String name;
  final String? value;

  ComboData({required this.id, required this.name, this.value});

  factory ComboData.fromLevel(RacingLevel data) {
    return ComboData(id: data.racingLevelCode!, name: data.racingLevel!);
  }

  factory ComboData.fromType(RacingType data) {
    return ComboData(id: data.racingTypeCode!, name: data.racingType!);
  }

  RacingLevel toLevel(ComboData data) {
    return RacingLevel(racingLevelCode: data.id, racingLevel: data.name);
  }

  RacingType toType(ComboData data) {
    return RacingType(racingTypeCode: data.id, racingType: data.name);
  }
}
