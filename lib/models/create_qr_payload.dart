class CreateQRPayload {
  String eventId;
  int noOfScans;
  String expiryDate;
  int duration;
  String url;
  int noOfVideoLimit;
  int noOfImgLimit;

  CreateQRPayload(
      {this.eventId,
        this.noOfScans,
        this.expiryDate,
        this.duration,
        this.url,
        this.noOfVideoLimit,
        this.noOfImgLimit});

  CreateQRPayload.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    noOfScans = json['noOfScans'];
    expiryDate = json['expiryDate'];
    duration = json['duration'];
    url = json['url'];
    noOfVideoLimit = json['noOfVideoLimit'];
    noOfImgLimit = json['noOfImgLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.eventId;
    data['noOfScans'] = this.noOfScans;
    data['expiryDate'] = this.expiryDate;
    data['duration'] = this.duration;
    data['url'] = this.url;
    data['noOfVideoLimit'] = this.noOfVideoLimit;
    data['noOfImgLimit'] = this.noOfImgLimit;
    return data;
  }
}