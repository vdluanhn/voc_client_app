import 'dart:core';

import 'package:voc_client_app/models/TimeEvents.dart';
import 'package:voc_client_app/models/Violations.dart';

class Racing {
  int? racingId;
  int? teamId;
  String? racingLevelCode;
  String? racingTypeCode;
  DateTime? checkinTime;
  Object? inoutDuration;
  bool? firstRacingInDay;
  int? repairTimes;
  Object? startRepairTime;
  String? recognizedByTeamDate;
  Object? recognizedByTeamComment;
  bool? forceRecognized;
  Object? forceRecognizedDate;
  Object? forceRecognizedComment;
  Object? racingCancelation;
  int? totalTimeMilis;
  String? status;
  List<TimeEvents>? timeEvents;
  List<Violations>? violations;
  String? insertDatetime;
  bool? completed;
  bool? cancelled;
  String? recognizedDate;
  bool? recognized;
  bool? checkin;
  String? racingState;
  bool? start;
  bool? finish;
  bool? recognizedByTeam;
  int? grandTotalTime;
  TimeEvents? finishEvent;
  TimeEvents? startEvent;
  int? repairTimeToNowInSecond;
  bool? finishedAndRecognized;
  int? totalViolationTime;
  bool? cancelledAndRecognized;
  String? recognizedDateSafe;
  bool? requestRepairTimes;
  String? recognitionState;
  int? repairTimeRemainInSeconds;

  Racing(
      {this.racingId,
      this.teamId,
      this.racingLevelCode,
      this.racingTypeCode,
      this.checkinTime,
      this.inoutDuration,
      this.firstRacingInDay,
      this.repairTimes,
      this.startRepairTime,
      this.recognizedByTeamDate,
      this.recognizedByTeamComment,
      this.forceRecognized,
      this.forceRecognizedDate,
      this.forceRecognizedComment,
      this.racingCancelation,
      this.totalTimeMilis,
      this.status,
      this.timeEvents,
      this.violations,
      this.insertDatetime,
      this.completed,
      this.cancelled,
      this.recognizedDate,
      this.recognized,
      this.checkin,
      this.racingState,
      this.start,
      this.finish,
      this.recognizedByTeam,
      this.grandTotalTime,
      this.finishEvent,
      this.startEvent,
      this.repairTimeToNowInSecond,
      this.finishedAndRecognized,
      this.totalViolationTime,
      this.cancelledAndRecognized,
      this.recognizedDateSafe,
      this.requestRepairTimes,
      this.recognitionState,
      this.repairTimeRemainInSeconds});
  Racing.fromJson(Map<String, dynamic> json) {
    racingId = json['racing_id'];
    teamId = json['team_id'];
    racingLevelCode = json['racing_level_code'];
    racingTypeCode = json['racing_type_code'];
    checkinTime = json['checkin_time'] == null ? null : DateTime.tryParse(json['checkin_time']);
    inoutDuration = json['inout_duration'];
    firstRacingInDay = json['first_racing_in_day'];
    repairTimes = json['repair_times'];
    startRepairTime = json['start_repair_time'];
    recognizedByTeamDate = json['recognized_by_team_date'];
    recognizedByTeamComment = json['recognized_by_team_comment'];
    forceRecognized = json['force_recognized'];
    forceRecognizedDate = json['force_recognized_date'];
    forceRecognizedComment = json['force_recognized_comment'];
    racingCancelation = json['racing_cancelation'];
    totalTimeMilis = json['total_time_milis'];
    status = json['status'];
    if (json['time_events'] != null) {
      timeEvents = <TimeEvents>[];
      json['time_events'].forEach((v) {
        timeEvents!.add(TimeEvents.fromJson(v));
      });
    }
    if (json['violations'] != null) {
      violations = <Violations>[];
      json['violations'].forEach((v) {
        violations!.add(Violations.fromJson(v));
      });
    }
    insertDatetime = json['insert_datetime'];
    completed = json['completed'];
    cancelled = json['cancelled'];
    recognizedDate = json['recognized_date'];
    recognized = json['recognized'];
    checkin = json['checkin'];
    racingState = json['racing_state'];
    start = json['start'];
    finish = json['finish'];
    recognizedByTeam = json['recognized_by_team'];
    grandTotalTime = json['grand_total_time'];
    finishEvent = json['finish_event'] != null ? TimeEvents.fromJson(json['finish_event']) : null;
    startEvent = json['start_event'] != null ? TimeEvents.fromJson(json['start_event']) : null;
    repairTimeToNowInSecond = json['repair_time_to_now_in_second'];
    finishedAndRecognized = json['finished_and_recognized'];
    totalViolationTime = json['total_violation_time'];
    cancelledAndRecognized = json['cancelled_and_recognized'];
    recognizedDateSafe = json['recognized_date_safe'];
    requestRepairTimes = json['request_repair_times'];
    recognitionState = json['recognition_state'];
    repairTimeRemainInSeconds = json['repair_time_remain_in_seconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['racing_id'] = racingId;
    data['team_id'] = teamId;
    data['racing_level_code'] = racingLevelCode;
    data['racing_type_code'] = racingTypeCode;
    data['checkin_time'] = checkinTime;
    data['inout_duration'] = inoutDuration;
    data['first_racing_in_day'] = firstRacingInDay;
    data['repair_times'] = repairTimes;
    data['start_repair_time'] = startRepairTime;
    data['recognized_by_team_date'] = recognizedByTeamDate;
    data['recognized_by_team_comment'] = recognizedByTeamComment;
    data['force_recognized'] = forceRecognized;
    data['force_recognized_date'] = forceRecognizedDate;
    data['force_recognized_comment'] = forceRecognizedComment;
    data['racing_cancelation'] = racingCancelation;
    data['total_time_milis'] = totalTimeMilis;
    data['status'] = status;
    if (timeEvents != null) {
      data['time_events'] = timeEvents!.map((v) => v.toJson()).toList();
    }
    if (violations != null) {
      data['violations'] = violations!.map((v) => v.toJson()).toList();
    }
    data['insert_datetime'] = insertDatetime;
    data['completed'] = completed;
    data['cancelled'] = cancelled;
    data['recognized_date'] = recognizedDate;
    data['recognized'] = recognized;
    data['checkin'] = checkin;
    data['racing_state'] = racingState;
    data['start'] = start;
    data['finish'] = finish;
    data['recognized_by_team'] = recognizedByTeam;
    data['grand_total_time'] = grandTotalTime;
    if (finishEvent != null) {
      data['finish_event'] = finishEvent!.toJson();
    }
    if (startEvent != null) {
      data['start_event'] = startEvent!.toJson();
    }
    data['repair_time_to_now_in_second'] = repairTimeToNowInSecond;
    data['finished_and_recognized'] = finishedAndRecognized;
    data['total_violation_time'] = totalViolationTime;
    data['cancelled_and_recognized'] = cancelledAndRecognized;
    data['recognized_date_safe'] = recognizedDateSafe;
    data['request_repair_times'] = requestRepairTimes;
    data['recognition_state'] = recognitionState;
    data['repair_time_remain_in_seconds'] = repairTimeRemainInSeconds;
    return data;
  }
}
