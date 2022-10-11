import '../commons/model/ComboData.dart';

class RacingLevel {
  final String? racingLevelCode;
  final String? racingLevel;

  RacingLevel({
    this.racingLevelCode,
    this.racingLevel,
  });

  RacingLevel.fromJson(Map<String, dynamic> json)
      : racingLevelCode = json['racing_level_code'] as String?,
        racingLevel = json['racing_level'] as String?;

  Map<String, dynamic> toJson() => {'racing_level_code': racingLevelCode, 'racing_level': racingLevel};

  ComboData toComboData() {
    return ComboData(id: racingLevelCode!, name: racingLevel!, value: racingLevel);
  }
}
