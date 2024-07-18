import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesona2/repository/repository.dart';
import 'package:pesona2/screens/splash_screen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final NotifPermission notifPermit = NotifPermission();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await notifPermit.declareNotif();

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff315EFF), // Warna latar belakang daerah notifikasi
        statusBarIconBrightness: Brightness.light, // Kecerahan ikon
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}

