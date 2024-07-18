import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesona2/routes/calendar.dart';
import '../routes/profile_screen.dart';
import '../learning routes/keuangan.dart';
import '../model/navigator_model.dart';
import '../navigator/navbar_element.dart';
import '../repository/repository.dart';
import '../routes/home.dart';
import '../routes/learning.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavigatorModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavigatorModel(page: const Home(), navKey: homeNavKey,),
      NavigatorModel(page: const Calendar(), navKey: searchNavKey,),
      NavigatorModel(page: const LearningKeuanganScreen(), navKey: notificationNavKey,),
      NavigatorModel(page: const Profile(), navKey: profileNavKey,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return; // Tidak melakukan apa-apa jika operasi pop telah berhasil dilakukan
        }
          bool value = await showExitConfirmationDialog(context); // Mengambil nilai dari suatu fungsi
        if (value) {
          SystemNavigator.pop(); // Jika nilai adalah true, keluarkan navigator
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: items.map((page) => Navigator(
            key: page.navKey,
            onGenerateInitialRoutes: (navigator, initialRoute) {
              return [
                MaterialPageRoute(builder: (context) => page.page)
              ];
            },
          )).toList(),
        ),
        bottomNavigationBar: NavbarElement(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}