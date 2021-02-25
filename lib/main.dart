import 'package:camera/camera.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/screens/capture_screen.dart';
import 'package:eventklip/screens/privacy_policy_screen.dart';
import 'package:eventklip/screens/qr_users_home_screen.dart';
import 'package:eventklip/screens/qr_users_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eventklip/screens/account_settings_screen.dart';
import 'package:eventklip/screens/edit_profile_screen.dart';
import 'package:eventklip/screens/faq_screen.dart';
import 'package:eventklip/screens/help_screen.dart';
import 'package:eventklip/screens/home_screen.dart';
import 'package:eventklip/screens/onboarding_screen.dart';
import 'package:eventklip/screens/signin.dart';
import 'package:eventklip/screens/change_passwords_screen.dart';
import 'package:eventklip/screens/splash_screen.dart';
import 'package:eventklip/screens/terms_conditions_screen.dart';
import 'package:eventklip/utils/app_localizations.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:eventklip/utils/app_theme.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EventklipAppState("en", isDarkMode: true),
        child:
            Consumer<EventklipAppState>(builder: (context, provider, builder) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.black12,
            ),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              darkTheme: AppTheme.darkTheme,
              supportedLocales: [
                Locale('en', ''),
                Locale('fr', ''),
                Locale('af', ''),
                Locale('de', ''),
                Locale('es', ''),
                Locale('id', ''),
                Locale('pt', ''),
                Locale('tr', ''),
                Locale('hi', '')
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                return Locale(provider.selectedLanguageCode);
              },
              locale: provider.locale,
              themeMode:
                  provider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
              home: SplashScreen(),
              routes: <String, WidgetBuilder>{
                OnBoardingScreen.tag: (BuildContext context) =>
                    OnBoardingScreen(),
                SignInScreen.tag: (BuildContext context) => SignInScreen(),
                ChangePasswordScreen.tag: (BuildContext context) =>
                    ChangePasswordScreen(),
                HomeScreen.tag: (BuildContext context) => HomeScreen(),
                QrUsersHomeScreen.tag: (BuildContext context) => QrUsersHomeScreen(),
                AccountSettingsScreen.tag: (BuildContext context) =>
                    AccountSettingsScreen(),
                HelpScreen.tag: (BuildContext context) => HelpScreen(),
                FaqScreen.tag: (BuildContext context) => FaqScreen(),
                TermsConditionsScreen.tag: (BuildContext context) =>
                    TermsConditionsScreen(),
                PrivacyPolicyScreen.tag: (BuildContext context) =>
                    PrivacyPolicyScreen(),
                EditProfileScreen.tag: (BuildContext context) =>
                    EditProfileScreen(),
              },
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: ScrBehavior(),
                  child: child,
                );
              },
            ),
          );
        }));
  }
}

class ScrBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
