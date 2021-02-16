class SignUpPayload {
  String email;
  String contact;
  String fullname;
  String adminId;

  SignUpPayload({this.email, this.contact, this.fullname, this.adminId});

  SignUpPayload.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    contact = json['contact'];
    fullname = json['fullname'];
    adminId = json['adminId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['fullname'] = this.fullname;
    data['adminId'] = this.adminId;
    return data;
  }
}