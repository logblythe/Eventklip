class BasicServerResponse {
  bool success;
  String returnMsg;

  BasicServerResponse({this.success, this.returnMsg});

  BasicServerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    returnMsg = json['returnMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['returnMsg'] = this.returnMsg;
    return data;
  }
}

class BasicServerResponseWithObject {
  bool success;
  String returnMsg;
  String returnId;
  ReturnObject returnObject;

  BasicServerResponseWithObject(
      {this.success, this.returnMsg, this.returnId, this.returnObject});

  BasicServerResponseWithObject.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    returnMsg = json['returnMsg'];
    returnId = json['returnId'];
    returnObject = json['returnObject'] != null
        ? new ReturnObject.fromJson(json['returnObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['returnMsg'] = this.returnMsg;
    data['returnId'] = this.returnId;
    if (this.returnObject != null) {
      data['returnObject'] = this.returnObject.toJson();
    }
    return data;
  }
}

class ReturnObject {
  int duration;
  String eventId;
  String adminId;
  String eventName;
  String eventDesc;

  ReturnObject({this.duration, this.eventId, this.adminId});

  ReturnObject.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    eventId = json['eventId'];
    adminId = json['adminId'];
    eventDesc = json['eventDesc'];
    eventName = json['eventName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['eventId'] = this.eventId;
    data['adminId'] = this.adminId;
    data['eventName'] = this.eventName;
    data['eventDesc'] = this.eventDesc;
    return data;
  }
}
