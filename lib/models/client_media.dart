class ClientMedia {
  String id;
  String title;
  String duration;
  String fileLocation;
  String thumbnailLocation;
  String eventId;
  String eventName;
  String createdById;
  String uploadedBy;
  String createdDate;

  ClientMedia(
      {this.id,
        this.title,
        this.duration,
        this.fileLocation,
        this.thumbnailLocation,
        this.eventId,
        this.eventName,
        this.createdById,
        this.uploadedBy,
        this.createdDate});

  ClientMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    fileLocation = json['fileLocation'];
    thumbnailLocation = json['thumbnailLocation'];
    eventId = json['eventId'];
    eventName = json['eventName'];
    createdById = json['createdById'];
    uploadedBy = json['uploadedBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['duration'] = this.duration;
    data['fileLocation'] = this.fileLocation;
    data['thumbnailLocation'] = this.thumbnailLocation;
    data['eventId'] = this.eventId;
    data['eventName'] = this.eventName;
    data['createdById'] = this.createdById;
    data['uploadedBy'] = this.uploadedBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}