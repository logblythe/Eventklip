import 'package:eventklip/models/folder_model.dart';

class CreateQrModel {
  bool success;
  String returnMsg;
  FolderModel folderModel;

  CreateQrModel({this.success, this.returnMsg, this.folderModel});

  CreateQrModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    returnMsg = json['returnMsg'];
    folderModel = json['returnJSONObj'] != null
        ? new FolderModel.fromJson(json['returnJSONObj'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['returnMsg'] = this.returnMsg;
    if (this.folderModel != null) {
      data['returnJSONObj'] = this.folderModel.toJson();
    }
    return data;
  }
}
