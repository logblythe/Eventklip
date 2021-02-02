class AddCommentPayload {
  String videoId;
  String commentId;
  String timeSpan;
  String comment;

  AddCommentPayload(
      {
        this.videoId,
        this.commentId,
        this.timeSpan,
        this.comment});

  AddCommentPayload.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    commentId = json['commentId'];
    timeSpan = json['timeSpan'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoId'] = this.videoId;
    data['commentId'] = this.commentId;
    data['timeSpan'] = this.timeSpan;
    data['comment'] = this.comment;
    return data;
  }
}
