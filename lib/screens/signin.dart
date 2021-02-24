import 'dart:async';
import 'dart:io';
import 'package:eventklip/models/failure.dart';
import 'package:eventklip/screens/forgot_password_screen.dart';
import 'package:eventklip/screens/qr_scanner_view.dart';
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
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:eventklip/utils/widget_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool passwordVisible = false;
  bool isLoading = false;

  String email;
  String password;
  String errorMessage;
  String _redirectedToUrl;
  bool _isWebViewLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
      errorMessage = null;
    });
  }

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print(url);
    });
    super.initState();
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
      child: button(
        context,
        keyString(context, "login"),
        () {
          doSignIn(context);
          hideKeyboard(context);
        },
      ),
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
          )
            .paddingSymmetric(horizontal: spacing_standard_new)
            .paddingBottom(spacing_standard_new)
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
                          left: spacing_standard_new,
                          right: spacing_large),
                  form.paddingOnly(
                      left: spacing_standard_new,
                      right: spacing_standard_new,
                      top: spacing_large),
                  Container(
                    padding: EdgeInsets.only(
                        right: spacing_standard_new,
                        left: spacing_standard_new,
                        top: spacing_standard_new,
                        bottom: spacing_standard),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: text(context, keyString(context, "sign_up"),
                              fontSize: ts_medium,
                              textColor: colorPrimary,
                              aDecoration: TextDecoration.underline),
                          onTap: () {
                            _launchWebView();
                          },
                        ),
                        text(context, keyString(context, "forgot_pswd"),
                                fontSize: ts_medium, textColor: Colors.grey)
                            .paddingSymmetric(vertical: spacing_standard_new)
                            .onTap(() {
                          onForgotPasswordClicked(context);
                          hideKeyboardAndFocus();
                        }),
                      ],
                    ),
                  ),
                  errorBox,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: signinButton.paddingOnly(
                          left: spacing_standard_new,
                          right: spacing_standard_new,
                        ),
                      ),
                      FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          child: Icon(
                            Icons.qr_code_scanner_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return QRScanner();
                            }));
                          })
                    ],
                  ).paddingOnly(right: spacing_standard_new, bottom: 40)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                muviTitle(context).paddingAll(spacing_large),
              ],
            ),
            Center(child: loadingWidgetMaker().visible(isLoading)),
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

  void doSignIn(context) async {
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

  Future<void> _launchWebView() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return WebViewEventClip();
    }));
    passwordController.text = "";
  }
}

class WebViewEventClip extends StatefulWidget {
  @override
  _WebViewEventClipState createState() => _WebViewEventClipState();
}

class _WebViewEventClipState extends State<WebViewEventClip> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if (url.contains("https://dev.boxklip.com/Home/Dashboard")) {
          Navigator.of(context).pop();
          toast("Thank you for signing up with us. Please login.");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      // url: 'https://boxklip.com/Account/Register?BuyId=47992fe9-0601-499a-8f2e-4d88ec6c3932',
      url: 'https://dev.boxklip.com/Account/Register?BuyId=47992fe9-0601-499a-8f2e-4d88ec6c3932',
      appBar: new AppBar(
        title: const Text('EventKlip'),
      ),
      ignoreSSLErrors: true,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                flutterWebViewPlugin.goBack();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                flutterWebViewPlugin.goForward();
              },
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
          ],
        ),
      ),
      withOverviewMode: true,
      withZoom: true,
      withLocalStorage: true,
      initialChild: Container(
        child: Center(
          child: Loader(),
        ),
      ),
    );
  }
}
