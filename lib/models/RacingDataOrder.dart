import 'package:voc_client_app/models/Racing.dart';
import 'package:voc_client_app/models/Team.dart';

class RacingDataOrder {
  Team? team;
  Racing? racing;
  Object? prevRecognized;
  Object? prevRecognizedDuration;

  RacingDataOrder({this.team, this.racing, this.prevRecognized, this.prevRecognizedDuration});

  RacingDataOrder.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? Team.fromJson(json['team']) : null;
    racing = json['racing'] != null ? Racing.fromJson(json['racing']) : null;
    prevRecognized = json['prev_recognized'];
    prevRecognizedDuration = json['prev_recognized_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (team != null) {
      data['team'] = team!.toJson();
    }
    if (racing != null) {
      data['racing'] = racing!.toJson();
    }
    data['prev_recognized'] = prevRecognized;
    data['prev_recognized_duration'] = prevRecognizedDuration;
    return data;
  }
}
