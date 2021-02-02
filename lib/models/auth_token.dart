class AuthToken {
  String accessToken;
  String userName;

  AuthToken({this.accessToken, this.userName});

  AuthToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_Token'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_Token'] = this.accessToken;
    data['userName'] = this.userName;
    return data;
  }
}