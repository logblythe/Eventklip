class HomeMovieModel {
  List<ApplicationGroups> applicationGroups;
  List<VideoDetails> videoDetails;
  VideoDetails featuredVideo;

  HomeMovieModel(
      {this.applicationGroups, this.videoDetails, this.featuredVideo});

  HomeMovieModel.fromJson(Map<String, dynamic> json) {
    if (json['applicationGroups'] != null) {
      applicationGroups = new List<ApplicationGroups>();
      json['applicationGroups'].forEach((v) {
        applicationGroups.add(new ApplicationGroups.fromJson(v));
      });
    }
    if (json['videoDetails'] != null) {
      videoDetails = new List<VideoDetails>();
      json['videoDetails'].forEach((v) {
        videoDetails.add(new VideoDetails.fromJson(v));
      });
    }
    featuredVideo = json['featuredVideo'] != null
        ? new VideoDetails.fromJson(json['featuredVideo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.applicationGroups != null) {
      data['applicationGroups'] =
          this.applicationGroups.map((v) => v.toJson()).toList();
    }
    if (this.videoDetails != null) {
      data['videoDetails'] = this.videoDetails.map((v) => v.toJson()).toList();
    }
    if (this.featuredVideo != null) {
      data['featuredVideo'] = this.featuredVideo.toJson();
    }
    return data;
  }
}

class ApplicationGroups {
  String name;
  String groupType;
  String description;
  String id;
  String createdById;
  String createdOn;
  String lastModifiedDate;
  int modifiedTimes;
  int recordStatus;
  bool deletedStatus;
  Null applicationUser;

  ApplicationGroups(
      {this.name,
        this.groupType,
        this.description,
        this.id,
        this.createdById,
        this.createdOn,
        this.lastModifiedDate,
        this.modifiedTimes,
        this.recordStatus,
        this.deletedStatus,
        this.applicationUser});

  ApplicationGroups.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    groupType = json['groupType'];
    description = json['description'];
    id = json['id'];
    createdById = json['createdById'];
    createdOn = json['createdOn'];
    lastModifiedDate = json['lastModifiedDate'];
    modifiedTimes = json['modifiedTimes'];
    recordStatus = json['record_Status'];
    deletedStatus = json['deleted_Status'];
    applicationUser = json['applicationUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['groupType'] = this.groupType;
    data['description'] = this.description;
    data['id'] = this.id;
    data['createdById'] = this.createdById;
    data['createdOn'] = this.createdOn;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['modifiedTimes'] = this.modifiedTimes;
    data['record_Status'] = this.recordStatus;
    data['deleted_Status'] = this.deletedStatus;
    data['applicationUser'] = this.applicationUser;
    return data;
  }
}

class VideoDetails {
  String id;
  String title;
  String description;
  String duration;
  String img;
  String videoFormat;
  String fileLocation;
  int videoSize;
  int videoStatus;
  bool isDownloadable;
  bool canComment;
  String thumbnailLocation;
  List<String> videoTags;
  int views;
  Null applicationGroups;
  List<String> grpId;
  Null groups;
  Null relatedVideos;
  String createdOn;
  String language;
  int releaseYear;
  Null allComments;
  String owner;

  get isHD=>true;
  get percent=>0.5;
  VideoDetails(
      {this.id,
        this.title,
        this.description,
        this.duration,
        this.img,
        this.videoFormat,
        this.fileLocation,
        this.videoSize,
        this.videoStatus,
        this.isDownloadable,
        this.canComment,
        this.thumbnailLocation,
        this.videoTags,
        this.views,
        this.applicationGroups,
        this.grpId,
        this.groups,
        this.relatedVideos,
        this.createdOn,
        this.language,
        this.releaseYear,
        this.allComments,
        this.owner});

  VideoDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
    img = json['img'];
    videoFormat = json['videoFormat'];
    fileLocation = json['fileLocation'];
    videoSize = json['videoSize'];
    videoStatus = json['video_Status'];
    isDownloadable = json['isDownloadable'];
    canComment = json['canComment'];
    thumbnailLocation = json['thumbnailLocation'];
    videoTags = json['videoTags']?.cast<String>();
    views = json['views'];
    applicationGroups = json['applicationGroups'];
    grpId = json['grpId']?.cast<String>();
    groups = json['groups'];
    relatedVideos = json['relatedVideos'];
    createdOn = json['createdOn'];
    language = json['language'];
    releaseYear = json['releaseYear'];
    allComments = json['allComments'];
    owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['img'] = this.img;
    data['videoFormat'] = this.videoFormat;
    data['fileLocation'] = this.fileLocation;
    data['videoSize'] = this.videoSize;
    data['video_Status'] = this.videoStatus;
    data['isDownloadable'] = this.isDownloadable;
    data['canComment'] = this.canComment;
    data['thumbnailLocation'] = this.thumbnailLocation;
    data['videoTags'] = this.videoTags;
    data['views'] = this.views;
    data['applicationGroups'] = this.applicationGroups;
    data['grpId'] = this.grpId;
    data['groups'] = this.groups;
    data['relatedVideos'] = this.relatedVideos;
    data['createdOn'] = this.createdOn;
    data['language'] = this.language;
    data['releaseYear'] = this.releaseYear;
    data['allComments'] = this.allComments;
    data['owner'] = this.owner;
    return data;
  }
}