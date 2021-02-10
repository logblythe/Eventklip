class FolderModel {
  String id;
  String name;
  String description;
  bool isActive;
  Null parentFolder;
  Null createdById;
  String createdDate;
  Null applicationUser;

  FolderModel(
      {this.id,
        this.name,
        this.description,
        this.isActive,
        this.parentFolder,
        this.createdById,
        this.createdDate,
        this.applicationUser});

  FolderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
    parentFolder = json['parentFolder'];
    createdById = json['createdById'];
    createdDate = json['createdDate'];
    applicationUser = json['applicationUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['parentFolder'] = this.parentFolder;
    data['createdById'] = this.createdById;
    data['createdDate'] = this.createdDate;
    data['applicationUser'] = this.applicationUser;
    return data;
  }
}
