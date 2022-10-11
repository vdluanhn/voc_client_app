class Violations {
  int? racingViolationId;
  int? racingId;
  String? violationTypeCode;
  String? violationType;
  int? violationNumber;
  int? quantity;

  Violations({this.racingViolationId, this.racingId, this.violationTypeCode, this.violationType, this.violationNumber, this.quantity});

  Violations.fromJson(Map<String, dynamic> json) {
    racingViolationId = json['racing_violation_id'];
    racingId = json['racing_id'];
    violationTypeCode = json['violation_type_code'];
    violationType = json['violation_type'];
    violationNumber = json['violation_number'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['racing_violation_id'] = this.racingViolationId;
    data['racing_id'] = this.racingId;
    data['violation_type_code'] = this.violationTypeCode;
    data['violation_type'] = this.violationType;
    data['violation_number'] = this.violationNumber;
    data['quantity'] = this.quantity;
    return data;
  }
}
