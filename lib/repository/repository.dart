import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class AuthService{

  Future<User?> loginUser(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch (e) {
      log("something wrong");
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> refreshToken() async {
    try {
      // Mendapatkan pengguna yang saat ini masuk
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Mendapatkan ID token baru dengan memaksa refresh
        String? idToken = await user.getIdToken(true);
        print("Token refreshed, new ID token: $idToken");
        return idToken;
      } else {
        print("No user currently signed in.");
        return null;
      }
    } catch (e) {
      // Menangani pengecualian dan menampilkan pesan kesalahan
      print("Error refreshing token: $e");
      return null;
    }
  }
}

class DatabaseService {
  final _database = FirebaseDatabase.instance.ref("approval");

  Future<int?> fetchApprovalCount() async {
    try {
      final query = _database.orderByChild('status').equalTo('P');
      final snapshot = await query.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data.length.toInt();
      } else {
        print('No approval data found.');
        return 0;
      }
    } catch (error) {
      print('Error fetching approval data: $error');
      return null;
    }
  }

  Future<List<dynamic>> fetchApprovalSnapshot() async {
    try {
      final query = _database.orderByChild('status').equalTo('P');
      final snapshot = await query.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final approvals = data.entries.map((entry) => entry.value).toList();

        // Mengurutkan berdasarkan `date_created` dari terbaru hingga terlama
        approvals.sort((a, b) {
          // Ambil `date_created` dari masing-masing item, dan berikan default value jika null
          String dateAStr = a['date_created'] ?? '0000-00-00T00:00:00Z';
          String dateBStr = b['date_created'] ?? '0000-00-00T00:00:00Z';

          DateTime dateA = DateTime.parse(dateAStr);
          DateTime dateB = DateTime.parse(dateBStr);
          return dateB.compareTo(dateA); // Mengurutkan dari terbaru ke terlama
        });

        return approvals;
      } else {
        print('No approval data found.');
        return [];
      }
    } catch (error) {
      print('Error fetching approval data: $error');
      return [];
    }
  }
}

class NewsAndEventData {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> fetchImageUrls() async {
    List<Map<String, dynamic>> imageUrls = [];
    try {
      DatabaseReference ref = _database.ref('news');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        for (var entry in data.entries) {
          final value = Map<String, dynamic>.from(entry.value);
          if (value['is_carousel'] == 'Y' && value['is_active'] == 'Y') {
            String fileName = value['thumbnail'];
            String imageUrl = await _getImageUrl(fileName);
            imageUrls.add({'imageUrl': imageUrl, 'newsData': value});
          }
        }
      }
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
    return imageUrls;
  }

  Future<List<Map<String, dynamic>>> fetchEvent() async {
    List<Map<String, dynamic>> imageUrls = [];
    try {
      DatabaseReference ref = _database.ref('event');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        DateTime currentDate = DateTime.now();
        DateFormat dateFormat = DateFormat('MM/dd/yyyy');

        for (var entry in data.entries) {
          final value = Map<String, dynamic>.from(entry.value);

          String? startDateString = value['startDate'];
          String? endDateString = value['endDate'];

          if (startDateString != null && endDateString != null) {
            DateTime startDate = dateFormat.parse(startDateString);
            DateTime endDate = dateFormat.parse(endDateString);

            if (currentDate.isAfter(startDate) && (currentDate.isBefore(endDate.add(const Duration(days: 1))))) {
              String fileName = value['thumbnail'];
              String imageUrl = await _getImageUrl(fileName);
              imageUrls.add({'imageUrl': imageUrl, 'eventData': value});
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
    return imageUrls;
  }

  Future<String> _getImageUrl(String fileName) async {
    try {
      String imageUrl = await _storage.ref('Images/$fileName').getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return '';
    }
  }
}

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Exit Confirmation'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Mengembalikan false jika batal
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Mengembalikan true jika konfirmasi keluar
            },
            child: Text('Exit'),
          ),
        ],
      );
    },
  ) ?? false; // Mengembalikan false jika dialog ditutup secara tidak langsung
}

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to Logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Mengembalikan false jika batal
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Mengembalikan true jika konfirmasi keluar
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
  ) ?? false; // Mengembalikan false jika dialog ditutup secara tidak langsung
}

class NotifPermission {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final Function()? onNotificationTapCallback;

  NotifPermission({this.onNotificationTapCallback});

  Future<void> declareNotif() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Deklarasi saluran notifikasi
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'approval_channel', // ID Saluran
      'Approval Notifications', // Nama Saluran
      importance: Importance.max,
    );

    // Deklarasi AndroidInitializationSettings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Deklarasi iOS/MacOS Initialization Settings
    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) async {
      //   // Handle notification received in foreground
      // },
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        if (notificationResponse.payload == 'approval') {
          if (onNotificationTapCallback != null) {
            onNotificationTapCallback!();  // Panggil callback saat notifikasi diklik
          }
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    declarePermission();
  }

  Future<void> declarePermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
      // You might want to store grantedNotificationPermission for future use
    }
  }

  Future<void> showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'approval_channel', // ID Saluran harus sesuai dengan yang dideklarasikan di atas
      'Approval Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Anda punya approval baru', // Judul notifikasi
      'Ketuk untuk membuka halaman approval', // Isi notifikasi
      platformChannelSpecifics,
      payload: 'approval', // Payload yang bisa digunakan saat notifikasi diketuk
    );
  }

  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showNotification(notification.title, notification.body);
      }
    });

    _firebaseMessaging.subscribeToTopic('approval_notifications');
  }

  void listenForApprovalChanges(Function onNewApproval) {
    FirebaseDatabase.instance.ref().child('approval').orderByChild('status').equalTo('P').onChildAdded.listen((event) {
      final newApproval = event.snapshot.value;
      if (newApproval != null) {
        onNewApproval(newApproval);
      }
    });
  }
}