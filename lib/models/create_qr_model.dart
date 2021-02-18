class CreateQrModel {
  bool success;
  String returnMsg;

  CreateQrModel({this.success, this.returnMsg});

  CreateQrModel.fromJson(Map<String, dynamic> json) {
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