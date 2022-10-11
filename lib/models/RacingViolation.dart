class RacingViolation {
  final String? violationTypeCode;
  final int quantity;

  RacingViolation({
    this.violationTypeCode,
    this.quantity = 0,
  });

  RacingViolation.fromJson(Map<String, dynamic> json)
      : violationTypeCode = json['violation_type_code'] as String?,
        quantity = (json['quantity'] ?? "0").toInt();

  Map<String, dynamic> toJson() => {'violation_type_code': violationTypeCode, 'quantity': quantity};
}
