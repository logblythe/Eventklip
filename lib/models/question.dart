class Question {
  String id;
  String question;
  String eventId;
  String createdById;
  String lastModifiedDate;
  String answerUrl;
  int duration;
  bool isAnswered = false;


  Question({this.id,this.question, this.eventId, this.createdById, this.duration});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    eventId = json['eventId'];
    createdById = json['createdById'];
    lastModifiedDate = json['lastModifiedDate'];
    duration = json['duration'];
    answerUrl = json['answerURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['eventId'] = this.eventId;
    data['createdById'] = this.createdById;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['duration'] = this.duration;
    data['answerURL'] = this.answerUrl;
    return data;
  }
}
