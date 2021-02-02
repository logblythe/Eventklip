import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comment {
  String id;
  String timeSpan;
  String username;
  DateTime commentedOn;
  String comment;
  Color color;
  UserN userN;

  Comment(
      {this.id,
      this.timeSpan,
      this.username,
      this.commentedOn,
      this.color,
      this.comment,
      this.userN});

  String get commentExpressionTitle =>
      "$username - ${timeago.format(commentedOn)}";


  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeSpan = json['timeSpan'];
    username = json['username'];
    commentedOn =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['commentedOn'], true);
    comment = json['comment'];
    userN = json['userN'] != null ? new UserN.fromJson(json['userN']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timeSpan'] = this.timeSpan;
    data['username'] = this.username;
    data['commentedOn'] = this.commentedOn;
    data['comment'] = this.comment;
    if (this.userN != null) {
      data['userN'] = this.userN.toJson();
    }
    return data;
  }
}

class UserN {
  String id;
  String userName;
  String normalizedUserName;
  String email;
  String normalizedEmail;
  bool emailConfirmed;
  String passwordHash;
  String securityStamp;
  String concurrencyStamp;
  String phoneNumber;
  bool phoneNumberConfirmed;
  bool twoFactorEnabled;
  String lockoutEnd;
  bool lockoutEnabled;
  int accessFailedCount;
  String fullname;
  String contact;
  String country;
  String organization;
  String workTitle;
  String adminId;
  bool isPasswordUpdated;

  UserN(
      {this.id,
      this.userName,
      this.normalizedUserName,
      this.email,
      this.normalizedEmail,
      this.emailConfirmed,
      this.passwordHash,
      this.securityStamp,
      this.concurrencyStamp,
      this.phoneNumber,
      this.phoneNumberConfirmed,
      this.twoFactorEnabled,
      this.lockoutEnd,
      this.lockoutEnabled,
      this.accessFailedCount,
      this.fullname,
      this.contact,
      this.country,
      this.organization,
      this.workTitle,
      this.adminId,
      this.isPasswordUpdated});

  UserN.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    normalizedUserName = json['normalizedUserName'];
    email = json['email'];
    normalizedEmail = json['normalizedEmail'];
    emailConfirmed = json['emailConfirmed'];
    passwordHash = json['passwordHash'];
    securityStamp = json['securityStamp'];
    concurrencyStamp = json['concurrencyStamp'];
    phoneNumber = json['phoneNumber'];
    phoneNumberConfirmed = json['phoneNumberConfirmed'];
    twoFactorEnabled = json['twoFactorEnabled'];
    lockoutEnd = json['lockoutEnd'];
    lockoutEnabled = json['lockoutEnabled'];
    accessFailedCount = json['accessFailedCount'];
    fullname = json['fullname'];
    contact = json['contact'];
    country = json['country'];
    organization = json['organization'];
    workTitle = json['workTitle'];
    adminId = json['adminId'];
    isPasswordUpdated = json['isPasswordUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['normalizedUserName'] = this.normalizedUserName;
    data['email'] = this.email;
    data['normalizedEmail'] = this.normalizedEmail;
    data['emailConfirmed'] = this.emailConfirmed;
    data['passwordHash'] = this.passwordHash;
    data['securityStamp'] = this.securityStamp;
    data['concurrencyStamp'] = this.concurrencyStamp;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumberConfirmed'] = this.phoneNumberConfirmed;
    data['twoFactorEnabled'] = this.twoFactorEnabled;
    data['lockoutEnd'] = this.lockoutEnd;
    data['lockoutEnabled'] = this.lockoutEnabled;
    data['accessFailedCount'] = this.accessFailedCount;
    data['fullname'] = this.fullname;
    data['contact'] = this.contact;
    data['country'] = this.country;
    data['organization'] = this.organization;
    data['workTitle'] = this.workTitle;
    data['adminId'] = this.adminId;
    data['isPasswordUpdated'] = this.isPasswordUpdated;
    return data;
  }
}
