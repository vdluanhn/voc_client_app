class TimeEvents {
  int? timeEventId;
  int? racingId;
  String? timeEventType;
  String? time;
  String? insertDatetime;
  String? status;
  bool? manualAdd;
  bool? active;
  bool? valid;
  bool? startType;
  bool? finishType;

  TimeEvents({this.timeEventId, this.racingId, this.timeEventType, this.time, this.insertDatetime, this.status, this.manualAdd, this.active, this.valid, this.startType, this.finishType});

  TimeEvents.fromJson(Map<String, dynamic> json) {
    timeEventId = json['time_event_id'];
    racingId = json['racing_id'];
    timeEventType = json['time_event_type'];
    time = json['time'];
    insertDatetime = json['insert_datetime'];
    status = json['status'];
    manualAdd = json['manual_add'];
    active = json['active'];
    valid = json['valid'];
    startType = json['start_type'];
    finishType = json['finish_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_event_id'] = this.timeEventId;
    data['racing_id'] = this.racingId;
    data['time_event_type'] = this.timeEventType;
    data['time'] = this.time;
    data['insert_datetime'] = this.insertDatetime;
    data['status'] = this.status;
    data['manual_add'] = this.manualAdd;
    data['active'] = this.active;
    data['valid'] = this.valid;
    data['start_type'] = this.startType;
    data['finish_type'] = this.finishType;
    return data;
  }
}
