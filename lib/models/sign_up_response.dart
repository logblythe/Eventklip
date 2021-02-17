class SignUpResponse {
  bool success;
  Null returnMsg;
  ReturnJSONObj returnJSONObj;

  SignUpResponse({this.success, this.returnMsg, this.returnJSONObj});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    returnMsg = json['returnMsg'];
    returnJSONObj = json['returnJSONObj'] != null
        ? new ReturnJSONObj.fromJson(json['returnJSONObj'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['returnMsg'] = this.returnMsg;
    if (this.returnJSONObj != null) {
      data['returnJSONObj'] = this.returnJSONObj.toJson();
    }
    return data;
  }
}

class ReturnJSONObj {
  Value value;

  ReturnJSONObj({
    this.value,
  });

  ReturnJSONObj.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.value != null) {
      data['value'] = this.value.toJson();
    }
    return data;
  }
}

class Value {
  String accessToken;
  String userName;

  Value({this.accessToken, this.userName});

  Value.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_Token'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_Token'] = this.accessToken;
    data['userName'] = this.userName;
    return data;
  }
}
