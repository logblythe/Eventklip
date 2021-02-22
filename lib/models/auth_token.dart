class AuthToken {
  String accessToken;
  String userName;

  AuthToken({this.accessToken, this.userName});

  AuthToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['userName'] = this.userName;
    return data;
  }
}