import '../commons/model/ComboData.dart';

class RacingType {
  final String? racingTypeCode;
  final String? racingType;

  RacingType({
    this.racingTypeCode,
    this.racingType,
  });

  RacingType.fromJson(Map<String, dynamic> json)
      : racingTypeCode = json['racing_type_code'] as String?,
        racingType = json['racing_type'] as String?;

  Map<String, dynamic> toJson() => {'racing_type_code': racingTypeCode, 'racing_type': racingType};

  ComboData toComboData() {
    return ComboData(id: racingTypeCode!, name: racingType!, value: racingType);
  }
}
