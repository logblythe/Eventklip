import 'package:eventklip/di/injection.dart';
import 'package:eventklip/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';
  final String password;

  const ChangePasswordScreen({Key key, this.password}) : super(key: key);

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  FocusNode passFocus = FocusNode();
  FocusNode oldPasswordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String oldPassword;
  String password;
  bool passwordObsecured = true;
  bool oldPasswordObsecured = true;
  bool isLoading = false;

  bool _loading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void initState() {
    super.initState();
    oldPassword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.password == null
              ? TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    return value.isEmpty
                        ? keyString(context, "error_old_pwd_requires")
                        : null;
                  },
                  onSaved: (String value) {
                    oldPassword = value;
                    print("Pugyo?");
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: oldPasswordFocus,
                  onFieldSubmitted: (arg) {
                    FocusScope.of(context).requestFocus(passFocus);
                  },
                  obscureText: oldPasswordObsecured,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).textTheme.headline6.color),
                    ),
                    labelText: keyString(context, "hint_old_password"),
                    labelStyle: TextStyle(
                        fontSize: ts_normal,
                        color: Theme.of(context).textTheme.headline6.color),
                    suffixIcon: new GestureDetector(
                      onTap: () {
                        setState(() {
                          oldPasswordObsecured = !oldPasswordObsecured;
                        });
                      },
                      child: new Icon(
                        oldPasswordObsecured
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    contentPadding: new EdgeInsets.only(bottom: 1.5),
                  ),
                  style: TextStyle(
                      fontSize: ts_normal,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontFamily: font_regular),
                ).paddingBottom(spacing_standard_new)
              : Container(),
          TextFormField(
            controller: _controller,
            obscureText: passwordObsecured,
            cursorColor: Theme.of(context).primaryColor,
            style: TextStyle(
                fontSize: ts_normal,
                color: Theme.of(context).textTheme.headline6.color,
                fontFamily: font_regular),
            validator: (value) {
              return value.isEmpty
                  ? keyString(context, "error_pwd_requires")
                  : value.length < 6
                      ? "The New password must be at least 6 characters long."
                      : null;
            },
            focusNode: passFocus,
            onSaved: (String value) {
              password = value;
            },
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(confirmPasswordFocus);
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
                labelText: keyString(context, "hint_password"),
                labelStyle: TextStyle(
                    fontSize: ts_normal,
                    color: Theme.of(context).textTheme.headline6.color),
                contentPadding: new EdgeInsets.only(bottom: 1.5),
                suffixIcon: new GestureDetector(
                  onTap: () {
                    setState(() {
                      passwordObsecured = !passwordObsecured;
                    });
                  },
                  child: new Icon(
                    passwordObsecured ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                )),
          ).paddingBottom(spacing_standard_new),
          TextFormField(
              obscureText: passwordObsecured,
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(
                  fontSize: ts_normal,
                  color: Theme.of(context).textTheme.headline6.color,
                  fontFamily: font_regular),
              focusNode: confirmPasswordFocus,
              validator: (value) {
                if (value.isEmpty) {
                  return keyString(context, "error_confirm_password_required");
                }
                return _controller.text == value
                    ? null
                    : keyString(context, "error_password_not_match");
              },
              textInputAction: TextInputAction.next,
              decoration: new InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).textTheme.headline6.color),
                ),
                labelText: keyString(context, "hint_confirm_password"),
                labelStyle: TextStyle(
                    fontSize: ts_normal,
                    color: Theme.of(context).textTheme.headline6.color),
                contentPadding:
                    EdgeInsets.only(bottom: 1.5, top: spacing_control),
                suffixIcon: new GestureDetector(
                  onTap: () {
                    setState(() {
                      passwordObsecured = !passwordObsecured;
                    });
                  },
                  child: new Icon(
                    passwordObsecured ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
              )),
        ],
      ),
    );
    var changePasswordButton = SizedBox(
      width: double.infinity,
      child: button(
          context,
          keyString(context, "change_password"),
          _loading
              ? null
              : () async {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    AuthenticationService _authService =
                        getIt.get<AuthenticationService>();
                    setState(() {
                      _loading = true;
                    });
                    hideKeyboard(context);
                    try {
                      final success = await _authService.changePassword(
                          newPassword: password, oldPassword: oldPassword);
                      if (success.success) {
                        toast("Successfully changed password",
                            length: Toast.LENGTH_LONG);
                        Navigator.of(context).pop();
                      } else {
                        toast("May be your old password is not correct");
                      }
                    } catch (e) {
                      toast("Something went wrong");
                    } finally {
                      setState(() {
                        _loading = false;
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
          _loading ? Loader() : Container(),
          SingleChildScrollView(
            child: IgnorePointer(
              ignoring: _loading,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text(context, "Change Password",
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
                    widget.password == null
                        ? keyString(context, "change_password_desc")
                        : keyString(context, "change_password_desc_first_time"),
                    fontSize: ts_normal,
                    textColor: Theme.of(context).textTheme.subtitle2.color,
                    maxLine: 2,
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
