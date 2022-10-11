
import '../../models/RacingViolation.dart';

abstract class IRacingService {
  Future start(String cardNumber, String racingTypeCode, String startTime);
  Future finish(String cardNumber, String racingTypeCode, String finishTime);
  Future completeByTeam(String cardNumber, String racingTypeCode, String? comment, String? racingCancelation, List<RacingViolation>? updateViolations);
  Future completeForce(String cardNumber, String racingTypeCode, String? comment, String? racingCancelation, List<RacingViolation>? updateViolations);
  Future undoRacing(String cardNumber, String racingTypeCode);
}
