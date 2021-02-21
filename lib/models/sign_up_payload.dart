class SignUpPayload {
  String email;
  String contact;
  String fullname;
  String adminId;
  String password;
  String confirmPassword;

  SignUpPayload({this.email, this.contact, this.fullname, this.adminId,this.password,this.confirmPassword});

  SignUpPayload.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    contact = json['contact'];
    fullname = json['fullname'];
    adminId = json['adminId'];
    password = json['password]'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['fullname'] = this.fullname;
    data['adminId'] = this.adminId;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    return data;
  }
}