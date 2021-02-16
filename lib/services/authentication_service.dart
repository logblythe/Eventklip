import 'package:eventklip/api/auth_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/auth_token.dart';
import 'package:eventklip/models/basic_server_response.dart';
import 'package:eventklip/models/sign_up_payload.dart';
import 'package:eventklip/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthenticationService {
  AuthApi _authApi = getIt.get<AuthApi>();

  Future<AuthToken> authenticate(String username, String password) {
    return _authApi.authenticateUser(username, password);
  }

  Future<UserProfile> getUserProfile() {
    return _authApi.getUserProfile();
  }

  Future<BasicServerResponse> sendPasswordForgotMail(String email) {
    return _authApi.sendPasswordForgotMail(email);
  }

  Future<BasicServerResponse> changePassword(
      {@required String newPassword, String oldPassword}) {
    return _authApi.changePassword(oldPassword, newPassword);
  }

  Future<BasicServerResponse> signUp(SignUpPayload payload) {
    return _authApi.signUp(payload);
  }
}
