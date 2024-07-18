import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:pesona2/screens/login_screen.dart';

import '../repository/repository.dart';
import '../Profile routes/detail_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<String> entries = <String>['Pengaturan Akun', 'Logout'];
  String? _displayName, _email, _phone, _photoURL;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    // if (mounted) {
      setState(() {
        _displayName = user?.displayName;
        _email = user?.email;
        // _phone = user?.phoneNumber;
        _photoURL = user?.photoURL;
      });
    // }
  }

  String formatPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.length <= 3) {
      return phoneNumber ?? '000';
    }
    final lastThreeDigits = phoneNumber.substring(phoneNumber.length - 3);
    final maskedDigits = '*' * (phoneNumber.length - 3);
    return '$maskedDigits$lastThreeDigits';
  }

  Future<void> signOutWithRefreshToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.getIdToken(true);
      await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  Widget profile() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 0),
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // CircleAvatar(
          //   radius: 43,
          //   backgroundImage: _photoURL != null ? NetworkImage(_photoURL!) : null,
          //   child: _photoURL == null
          //       ? Text(
          //     _displayName != null ? _displayName![0] : 'U',
          //     style: TextStyle(fontSize: 28),
          //   )
          //       : _isLoading ? Stack(
          //     children: [
          //       Container(
          //         width: 86, // Diameter CircleAvatar
          //         height: 86, // Diameter CircleAvatar
          //         decoration: BoxDecoration(
          //           color: Colors.grey.withOpacity(0.7),
          //           shape: BoxShape.circle,
          //         ),
          //       ),
          //       const Center(child: CircularProgressIndicator()),
          //     ],
          //   )
          //       : null,
          // ),
          Stack(
            children: [
                Container(
                  child: Stack(
                    children: [
                      Container(
                        width: 86, // Diameter CircleAvatar
                        height: 86, // Diameter CircleAvatar
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                ),
              ProfilePicture(
                name: _displayName ?? 'User',
                radius: 43,
                fontsize: 28,
                img: _photoURL,
                random: true,
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            width: screenWidth * 0.6, // Adjust the width as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName ?? 'Unknown User',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _email ?? 'Unknown User',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                // Text(
                //   formatPhoneNumber(_phone),
                //   style: GoogleFonts.montserrat(
                //     fontSize: 18,
                //     color: Colors.white,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget options() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            switch (index) {
              case 0:
                final result = await Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const detailProfile(),
                  ),
                );
                if (result == true) {
                  // Memuat ulang data pengguna setelah kembali dari layar ubah nama
                  getCurrentUser();
                }
                break;
              case 1:
                bool value = await showLogoutConfirmationDialog(context);
                if (value) {
                  await signOutWithRefreshToken(); // Melakukan logout
                }
                break;
            }
          },
          child: Container(
            color: Colors.white,
            height: 50,
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entries[index],
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            options(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff315EFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              profile(),
              body(),
            ],
          ),
        ),
      ),
    );
  }
}
