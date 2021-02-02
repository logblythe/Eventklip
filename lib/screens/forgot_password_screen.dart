import 'package:eventklip/di/injection.dart';
import 'package:eventklip/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String tag = '/ForgotPasswordScreen';

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  FocusNode passFocus = FocusNode();
  TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String email = "";

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _controller,
            cursorColor: Theme.of(context).primaryColor,
            style: TextStyle(
                fontSize: ts_normal,
                color: Theme.of(context).textTheme.headline6.color,
                fontFamily: font_regular),
            validator: (value) {
              return value.validateEmail() ? null : "Enter a valid email";
            },
            focusNode: passFocus,
            onSaved: (String value) {
              email = value;
            },
            textInputAction: TextInputAction.done,
            decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).textTheme.headline6.color),
              ),
              labelText: keyString(context, "hint_email"),
              labelStyle: TextStyle(
                  fontSize: ts_normal,
                  color: Theme.of(context).textTheme.headline6.color),
              contentPadding: new EdgeInsets.only(bottom: 1.5),
            ),
          ).paddingBottom(spacing_standard_new),
        ],
      ),
    );
    var changePasswordButton = SizedBox(
      width: double.infinity,
      child: button(
          context,
          keyString(context, "send_confirmation_mail"),
          isLoading
              ? null
              : () async {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    AuthenticationService _authService =
                        getIt.get<AuthenticationService>();
                    setState(() {
                      isLoading = true;
                    });
                    hideKeyboard(context);
                    try {
                      await _authService.sendPasswordForgotMail(email);
                      toast(
                          "Please check your mail for resetting your password.",
                          length: Toast.LENGTH_LONG);
                      Navigator.of(context).pop();
                    } catch (e) {
                      toast("Something went wrong");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                }),
    );
    return Scaffold(
      appBar: appBarLayout(context, "", darkBackground: false),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          isLoading ? Loader() : Container(),
          SingleChildScrollView(
            child: IgnorePointer(
              ignoring: isLoading,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text(context, "Recover Password",
                          fontSize: ts_xlarge,
                          textColor:
                              Theme.of(context).textTheme.headline6.color,
                          maxLine: 2,
                          fontFamily: font_bold,
                          isCentered: true)
                      .paddingOnly(
                          top: spacing_standard_new,
                          left: spacing_standard_new,
                          right: spacing_standard_new),
                  text(
                    context,
                    keyString(context, "forgot_password_desc"),
                    fontSize: ts_normal,
                    textColor: Theme.of(context).textTheme.subtitle2.color,
                    maxLine: 99,
                  ).paddingOnly(
                      top: spacing_control,
                      left: spacing_standard_new,
                      right: spacing_standard_new),
                  form.paddingOnly(
                      left: spacing_standard_new,
                      right: spacing_standard_new,
                      top: spacing_large,
                      bottom: spacing_standard_new),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: changePasswordButton.paddingOnly(
                        left: spacing_standard_new,
                        right: spacing_standard_new,
                        top: spacing_large,
                        bottom: spacing_standard_new),
                  ),
                ],
              ),
            ),
          ),
          Center(child: loadingWidgetMaker().visible(isLoading))
        ],
      ),
    );
  }
}
