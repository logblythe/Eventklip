import 'package:eventklip/di/injection.dart';
import 'package:eventklip/models/basic_server_response.dart';
import 'package:eventklip/models/sign_up_payload.dart';
import 'package:eventklip/models/user_profile.dart';
import 'package:eventklip/screens/qr_users_home_screen.dart';
import 'package:eventklip/screens/shared_preferences.dart';
import 'package:eventklip/services/authentication_service.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:eventklip/utils/widget_extensions.dart';

class SignUpScreen extends StatefulWidget {
  static String tag = '/SignUpScreen';

  final ReturnObject authDetails;

  const SignUpScreen({Key key, this.authDetails}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordVisible = false;
  bool isRemember = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _contactFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  var contact;
  var name;
  var userEmail;
  var password;
  bool isLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(context, "Sign up to EventClip"),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getForm().paddingTop(100),
                SizedBox(
                  width: double.infinity,
                  child: button(
                    context,
                    keyString(context, "sign_up"),
                    () async {
                      final form = _formKey.currentState;

                      if (form.validate()) {
                        form.save();
                        AuthenticationService _authService =
                            getIt.get<AuthenticationService>();
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final response = await _authService.signUp(
                              SignUpPayload(
                                  email: userEmail,
                                  adminId: widget.authDetails.adminId,
                                  contact: contact,
                                  confirmPassword: password,
                                  password: password,
                                  fullname: name));
                          if (response.success) {
                            await SharedPreferenceHelper.setUserProfile(
                                UserProfile(
                                    userName:
                                        response.returnJSONObj.value.userName,
                                    fullname: response.returnJSONObj.value.fullName,
                                    eventId: widget.authDetails.eventId,
                                    adminId: widget.authDetails.adminId));
                            await SharedPreferenceHelper.saveToken(
                                response.returnJSONObj.value.accessToken);
                            await SharedPreferenceHelper.setIsLoggedIn();
                            await SharedPreferenceHelper.setUserType(
                                UserType.CUSTOMER);

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) {
                              return QrUsersHomeScreen();
                            }), (r) => false);
                          } else {
                            toast("Something went wrong ${response.returnMsg}");
                          }
                        } catch (e) {
                          toast("Something went wrong");
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ).paddingOnly(top: 30, left: 18, right: 18, bottom: 30),
                )
              ],
            ),
          ),
          loadingWidgetMaker().visible(isLoading)
        ],
      ),
    );
  }

  Widget getForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          formField(
            context,
            "name",
            focusNode: _nameFocusNode,
            nextFocus: _contactFocusNode,
            validator: (value) {
              return value.isEmpty
                  ? keyString(context, "error_name_required")
                  : null;
            },
            onSaved: (String value) {
              name = value;
            },
            suffixIcon: Icons.person_outline,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "phone_no",
            focusNode: _contactFocusNode,
            nextFocus: _emailFocusNode,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: (value) {
              return value.isEmpty
                  ? keyString(context, "error_phone_requires")
                  : null;
            },
            onSaved: (String value) {
              contact = value;
            },
            suffixIcon: Icons.phone,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "hint_email",
            focusNode: _emailFocusNode,
            nextFocus: _passwordFocusNode,
            validator: (value) {
              return value.validateEMail(context);
            },
            onSaved: (String value) {
              userEmail = value;
            },
            suffixIcon: Icons.mail_outline,
          ).paddingBottom(spacing_standard_new),
          formField(
            context,
            "hint_password",
            isPassword: true,
            focusNode: _passwordFocusNode,
            isPasswordVisible: passwordVisible,
            textInputAction: TextInputAction.done,
            onSaved: (String value) {
              password = value;
            },
            suffixIconSelector: () {
              print("Select");
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
            suffixIcon:
                passwordVisible ? Icons.visibility : Icons.visibility_off,
          ).paddingBottom(spacing_standard_new),
        ],
      ),
    ).paddingOnly(
        left: spacing_standard_new, right: spacing_standard_new, top: 36);
  }
}
