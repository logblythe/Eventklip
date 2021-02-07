import 'package:eventklip/models/failure.dart';
import 'package:eventklip/screens/forgot_password_screen.dart';
import 'package:eventklip/services/stripe_service.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eventklip/screens/home_screen.dart';
import 'package:eventklip/screens/change_passwords_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:eventklip/utils/widget_extensions.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool passwordVisible = false;
  bool isLoading = false;

  String errorMessage;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: _formKey,
      child: IgnorePointer(
        ignoring: isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            formField(
              context,
              "hint_email",
              maxLine: 1,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                return value.validateEMail(context);
              },
              onSaved: (String value) {
                email = value;
              },
              textInputAction: TextInputAction.next,
              focusNode: emailFocus,
              nextFocus: passFocus,
              suffixIcon: Icons.mail_outline,
            ).paddingBottom(spacing_standard_new),
            formField(
              context,
              "hint_password",
              isPassword: true,
              controller: passwordController,
              isPasswordVisible: passwordVisible,
              validator: (value) {
                return value.isEmpty
                    ? keyString(context, "error_pwd_requires")
                    : null;
              },
              focusNode: passFocus,
              onSaved: (String value) {
                password = value;
              },
              textInputAction: TextInputAction.done,
              suffixIconSelector: () {
                print("Select");
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
              suffixIcon:
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
            )
          ],
        ),
      ),
    );
    var signinButton = SizedBox(
      width: double.infinity,
      child: button(context, keyString(context, "login"), () {
        doSignIn(context);
        hideKeyboard(context);
      }),
    );

    var errorBox = errorMessage != null
        ? Container(
            width: double.infinity,
            child: text(context, errorMessage),
            padding: EdgeInsets.all(spacing_standard_new),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
          ).paddingSymmetric(horizontal: spacing_standard_new)
        : Container();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            assetImage("assets/images/login_background.jpg",
                aWidth: double.infinity,
                aHeight: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.fitWidth),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  ],
                      stops: [
                    0.0,
                    0.5,
                    0.7,
                    1.0
                  ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      tileMode: TileMode.repeated)),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                      stops: [
                    0.0,
                    1.0
                  ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      tileMode: TileMode.repeated)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  text(context, keyString(context, "login"),
                          fontSize: ts_xlarge,
                          textColor:
                              Theme.of(context).textTheme.headline6.color,
                          maxLine: 2,
                          fontFamily: font_bold,
                          isCentered: true)
                      .paddingOnly(
                          top: spacing_control,
                          left: spacing_large,
                          right: spacing_large),
                  form.paddingOnly(
                      left: spacing_standard_new,
                      right: spacing_standard_new,
                      top: spacing_large),
                  Align(
                    alignment: Alignment.centerRight,
                    child: text(context, keyString(context, "forgot_pswd"),
                            fontSize: ts_medium, textColor: Colors.grey)
                        .paddingAll(spacing_standard_new)
                        .onTap(() {
                      onForgotPasswordClicked(context);
                      hideKeyboardAndFocus();
                    }),
                  ),
                  errorBox,
                  signinButton.paddingOnly(
                      left: spacing_standard_new,
                      right: spacing_standard_new,
                      top: spacing_large,
                      bottom: spacing_standard_new)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                muviTitle(context).paddingAll(spacing_large),
              ],
            ),
            Center(child: loadingWidgetMaker().visible(isLoading))
          ],
        ),
      ),
    );
  }

  onForgotPasswordClicked(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ForgotPasswordScreen();
    }));
  }

  doSignIn(context) async {
    final provider = Provider.of<EventklipAppState>(context, listen: false);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading(true);
      try {
        final profile = await provider.getUserProfile(email, password);
        showLoading(false);
        if (profile.isPasswordUpdated) {
          provider.setUserProfile(profile);
          launchScreenWithNewTask(context, HomeScreen.tag);
        } else {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ChangePasswordScreen(
              password: password,
            );
          }));
          passwordController.text = "";
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = (e as Failure).statusCode == 400
              ? "Your email or password is incorrect"
              : "Something went wrong";
        });
      }
    }
  }

  hideKeyboardAndFocus() {
    emailController.clear();
    passwordController.clear();
    hideKeyboard(context);
  }
}
