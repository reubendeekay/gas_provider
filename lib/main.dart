import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/firebase_options.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/providers/gas_providers.dart';
import 'package:gas_provider/providers/location_provider.dart';
import 'package:gas_provider/providers/request_provider.dart';
import 'package:gas_provider/screens/auth/login.dart';
import 'package:gas_provider/widgets/loading_screen.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LocationProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => GasProviders()),
        ChangeNotifierProvider(create: (ctx) => RequestProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gas Provider',
        theme: ThemeData(
            primarySwatch: MaterialColor(
              0xff47904C,
              <int, Color>{
                50: kIconColor.withOpacity(0.1),
                100: kIconColor.withOpacity(0.2),
                200: kIconColor.withOpacity(0.3),
                300: kIconColor.withOpacity(0.4),
                400: kIconColor.withOpacity(0.5),
                500: kIconColor.withOpacity(0.6),
                600: kIconColor.withOpacity(0.7),
                700: kIconColor.withOpacity(0.8),
                800: kIconColor.withOpacity(0.9),
                900: kIconColor,
              },
            ),
            appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarTextStyle: TextTheme(
                headline6: GoogleFonts.ibmPlexSans(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ).bodyText2,
              titleTextStyle: TextTheme(
                headline6: GoogleFonts.ibmPlexSans(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ).headline6,
            ),
            textTheme: GoogleFonts.ibmPlexSansTextTheme()),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const InitialLoadingScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
