import 'package:eventklip/api/api_helper.dart';
import 'package:eventklip/api/client.dart';
import 'package:eventklip/api/endpoints.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/interface/i_auth.dart';
import 'package:eventklip/models/auth_token.dart';
import 'package:eventklip/models/basic_server_response.dart';
import 'package:eventklip/models/sign_up_payload.dart';
import 'package:eventklip/models/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthApi extends IAuth with ApiHelper {
  DioClient _dioClient = getIt.get<DioClient>();

  @override
  Future<AuthToken> authenticateUser(String username, String password) async {
    Map<String, String> data = {"username": username, "password": password};
    final response =
        await _dioClient.post(ApiEndPoints.AUTHENTICATE, data: data);
    return returnResponse<AuthToken>(response,
        modelCreator: (json) => AuthToken.fromJson(json));
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final response = await _dioClient.post(ApiEndPoints.GET_PROFILE,
        options: Options(headers: await getDefaultHeader(authenticate: true)));
    return returnResponse<UserProfile>(response,
        modelCreator: (json) => UserProfile.fromJson(json));
  }

  @override
  Future<BasicServerResponse> sendPasswordForgotMail(String email) async {
    final response = await _dioClient.post(
      ApiEndPoints.FORGOT_PASSWORD,
      data: {"email": email},
      options: Options(
        headers: await getDefaultHeader(),
      ),
    );
    return returnResponse<BasicServerResponse>(response,
        modelCreator: (json) => BasicServerResponse.fromJson(json));
  }

  @override
  Future<BasicServerResponse> changePassword(
      String oldPassword, String newPassword) async {
    Map<String, String> data = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirmPassword": newPassword,
    };
    final response = await _dioClient.post(ApiEndPoints.CHANGE_PASSWORD,
        data: data,
        options: Options(headers: await getDefaultHeader(authenticate: true)));
    return returnResponse<BasicServerResponse>(response,
        modelCreator: (json) => BasicServerResponse.fromJson(json));
  }

  @override
  Future signUp(SignUpPayload payload) async {
    final response =
        await _dioClient.post(ApiEndPoints.SIGN_UP, data: payload.toJson());
    return returnResponse<BasicServerResponse>(response,
        modelCreator: (json) => BasicServerResponse.fromJson(json));
  }
}
