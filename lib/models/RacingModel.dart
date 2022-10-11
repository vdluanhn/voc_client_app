import 'package:uuid/uuid.dart';
import 'package:voc_client_app/commons/themes/helper.dart';
import 'package:voc_client_app/models/Team.dart';

enum RacingState { NOT_READY, READY, STARTED, FINISHED, COMPLETED, DISPOSED }

class RacingModel {
  static int LNH_TIME = 10000; // Thoi gian +10s loi nhe
  static int LNG_TIME = 30000; // Thoi gian +30s loi nang
  late String uuid = Uuid().v4();

  late Team? racingTeam = Team();

  late String? racingType;

  late RacingState currentRacingState = RacingState.NOT_READY;

  late RacingState? backupRacingState;

  late DateTime? start;

  late DateTime? finish;

  late DateTime? complete;

  late BigInt duration = BigInt.from(0);

  int lnh = 0; // So loi nhe

  int lng = 0; // So loi nang

  bool dnf = false;

  void onNotReady() {
    currentRacingState = RacingState.NOT_READY;

    start = null;
    finish = null;
    duration = BigInt.from(0);
  }

  void onReady() {
    currentRacingState = RacingState.READY;

    start = null;
    finish = null;
    duration = BigInt.from(0);
  }

  Future<DateTime> onStart(Team team, String racingType) async {
    if (currentRacingState != RacingState.READY) {
      throw Exception("Mã thẻ ${team.cardNumber} chưa sẵn sàng!");
    }
    racingTeam = team;
    this.racingType = racingType;
    start = DateTime.now();
    finish = null;
    duration = BigInt.from(0);
    currentRacingState = RacingState.STARTED;
    print("STARTED ${racingTeam?.cardNumber}");

    return start!;
  }

  Future<DateTime> onFinish(String rfid) async {
    if (rfid != racingTeam?.cardNumber!) throw Exception("Mã thẻ $rfid không đúng thẻ đang thi.");
    return finishTemp();
  }

  DateTime finishTemp() {
    if (currentRacingState != RacingState.STARTED) throw Exception("Chưa bắt đầu");

    finish = DateTime.now();
    duration = BigInt.from(0);
    duration = BigInt.from(finish!.millisecondsSinceEpoch - start!.millisecondsSinceEpoch);
    currentRacingState = RacingState.FINISHED;
    print("FINISH ${racingTeam?.cardNumber} in $duration ms");
    return finish!;
  }

  DateTime onDnf() {
    if (currentRacingState == RacingState.STARTED || currentRacingState == RacingState.FINISHED) {
      if (currentRacingState == RacingState.STARTED) finishTemp();
      dnf = true;
      return finish!;
    } else {
      throw Exception("DNF thực hiện khi đã bắt đầu hoặc kết thúc");
    }
  }

  void setLNH(int lnh) {
    validSetL(lnh);
    this.lnh = lnh;
  }

  void setLNG(int lng) {
    validSetL(lng);
    this.lng = lng;
  }

  void validSetL(int l) {
    if (l < 0) throw Exception("Số lỗi vi phạm không âm");

    if (currentRacingState != RacingState.FINISHED) throw Exception("Chưa kết thúc thi đấu");
  }

  int getLNH() {
    return lnh;
  }

  int getLNG() {
    return lng;
  }

  BigInt getLNHTime() {
    return BigInt.from(lnh * LNH_TIME);
  }

  BigInt getLNGTime() {
    return BigInt.from(lng * LNG_TIME);
  }

  BigInt getTotalL() {
    return getLNHTime() + getLNGTime();
  }

  BigInt getTotalTime() {
    return duration + getTotalL();
  }

  void onDispose() {
    backupRacingState = currentRacingState;
    currentRacingState = RacingState.DISPOSED;
  }

  void onUndoDispose() {
    currentRacingState = backupRacingState!;
    backupRacingState = null;
  }

  void onComplete() async {
    if (currentRacingState != RacingState.FINISHED) throw Exception("Chưa kết thúc thi đấu");

    complete = DateTime.now();
    currentRacingState = RacingState.COMPLETED;
  }

  bool allowFinish(int periodInSecond) {
    if (!isStart()) return false;
    return start!.add(Duration(seconds: periodInSecond)).isBefore(DateTime.now());
  }

  bool isNotReady() {
    return currentRacingState == RacingState.NOT_READY;
  }

  bool isReady() {
    return currentRacingState == RacingState.READY;
  }

  bool isStart() {
    return currentRacingState == RacingState.STARTED;
  }

  bool isFinish() {
    return currentRacingState == RacingState.FINISHED;
  }

  bool isCompleted() {
    return currentRacingState == RacingState.COMPLETED;
  }

  bool isDisposed() {
    return currentRacingState == RacingState.DISPOSED;
  }

  bool isRacing() {
    return isStart();
  }

  bool isDnf() {
    return dnf;
  }

  bool uuidEquals(String uuid) {
    if (isEmpty(uuid)) return false;

    if (this.uuid == uuid) return true;

    return false;
  }
}
