class Team {
  final int? teamId;
  final int? racingOrder;
  final String? teamName;
  final String? primaryDriver;
  final String? secondaryDriver;
  final String? carName;
  final String? carBrand;
  final String? carType;
  final String? etagNumber;
  final String? cardNumber;
  final String? racingLevelCode;
  final String? racingLevel;
  final dynamic eliminated;

  Team({
    this.teamId,
    this.racingOrder,
    this.teamName,
    this.primaryDriver,
    this.secondaryDriver,
    this.carName,
    this.carBrand,
    this.carType,
    this.etagNumber,
    this.cardNumber,
    this.racingLevelCode,
    this.racingLevel,
    this.eliminated,
  });

  Team.fromJson(Map<String, dynamic> json)
      : teamId = json['team_id'] as int?,
        racingOrder = json['racing_order'] as int?,
        teamName = json['team_name'] as String?,
        primaryDriver = json['primary_driver'] as String?,
        secondaryDriver = json['secondary_driver'] as String?,
        carName = json['car_name'] as String?,
        carBrand = json['car_brand'] as String?,
        carType = json['car_type'] as String?,
        etagNumber = json['etag_number'] as String?,
        cardNumber = json['card_number'] as String?,
        racingLevelCode = json['racing_level_code'] as String?,
        racingLevel = json['racing_level'] as String?,
        eliminated = json['eliminated'];

  Map<String, dynamic> toJson() => {
        'team_id': teamId,
        'racing_order': racingOrder,
        'team_name': teamName,
        'primary_driver': primaryDriver,
        'secondary_driver': secondaryDriver,
        'car_name': carName,
        'car_brand': carBrand,
        'car_type': carType,
        'etag_number': etagNumber,
        'card_number': cardNumber,
        'racing_level_code': racingLevelCode,
        'racing_level': racingLevel,
        'eliminated': eliminated
      };
}
