import 'package:evaluvatin_cloud_gallery/pages/Signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAppCheck.instance.activate(
  //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
  //   // argument for `webProvider`
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Safety Net provider
  //   // 3. Play Integrity provider
  //   androidProvider: AndroidProvider.debug,
  //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Device Check provider
  //   // 3. App Attest provider
  //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  //   appleProvider: AppleProvider.appAttest,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final bool isLoggedIn = snapshot.data ?? false;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isLoggedIn ? const SignupPage() :  const SignupPage(),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red).copyWith(surface: Colors.pink),
          ),
          title: "Cloud gallery",
        );
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}