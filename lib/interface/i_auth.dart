import 'package:eventklip/models/sign_up_payload.dart';

abstract class IAuth {
  Future authenticateUser(String username, String password);

  Future getUserProfile();

  Future changePassword(String oldPassword, String newPassword);
  Future sendPasswordForgotMail(String email);
  Future signUp(SignUpPayload payload);

}
