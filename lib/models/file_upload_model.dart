class FileUploadModel {
  bool success;
  String fileUrl;
  String fileId;

  FileUploadModel({this.success, this.fileUrl, this.fileId});

  FileUploadModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    fileUrl = json['returnMsg'];
    fileId = json['returnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['returnMsg'] = this.fileUrl;
    data['returnId'] = this.fileId;
    return data;
  }
}
