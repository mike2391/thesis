import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'change_name.dart';
import 'change_password.dart';

class detailProfile extends StatefulWidget {
  const detailProfile({super.key});

  @override
  State<detailProfile> createState() => _detailProfileState();
}

class _detailProfileState extends State<detailProfile> {
  // String? _displayName, _email, _phone, _photoURL;
  String? _displayName, _email, _photoURL;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      _displayName = user?.displayName;
      _email = user?.email;
      // _phone = user?.phoneNumber;
      _photoURL = user?.photoURL;
    });
  }

  Future<void> _updateProfilePicture(File file) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _isUploading = true; // Mulai proses unggah
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengupload gambar...')),
    );

    try {
      // Unggah gambar ke Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');
      await storageRef.putFile(file);

      // Dapatkan URL gambar yang diunggah
      final downloadURL = await storageRef.getDownloadURL();

      // Perbarui profil pengguna dengan URL gambar
      await user.updatePhotoURL(downloadURL);
      await user.reload();
      user = _auth.currentUser;

      setState(() {
        _photoURL = user?.photoURL;
        _isUploading = false; // Selesai unggah
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui foto profil: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _updateProfilePicture(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget picture() {
      final screenWidth = MediaQuery.of(context).size.width;
      return Container(
        margin: const EdgeInsets.only(top: 50, bottom: 50),
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child:  CircleAvatar(
                radius: 60,
                backgroundImage: _photoURL != null ? NetworkImage(_photoURL!) : null,
                child: _photoURL == null
                    ? Text(
                  _displayName != null ? _displayName![0] : 'U',
                  style: TextStyle(fontSize: 28),
                )
                    : _isUploading // Tampilkan indikator loading saat unggah gambar
                    ? Stack(
                  children: [
                    Container(
                      width: 120, // Diameter CircleAvatar
                      height: 120, // Diameter CircleAvatar
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Center(child: CircularProgressIndicator()),
                  ],
                )
                    : null,
              ),
            ),
          ],
        ),
      );
    }

    Widget infoRow(String label, {String? value}) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.sizeOf(context).width,
        color: Colors.white,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(value ?? ''),
          ],
        ),
      );
    }

    Widget modifyInfoRow(String label, Widget targetScreen, {String? value}) {
      return GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => targetScreen,
            ),
          );
          if (result == true) {
            // Memuat ulang data pengguna setelah kembali dari layar ubah nama
            getCurrentUser();
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.sizeOf(context).width,
          color: Colors.white,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(value ?? ''),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ],
          ),
        ),
      );
    }

    // String formatPhoneNumber(String? phoneNumber) {
    //   if (phoneNumber == null || phoneNumber.length <= 3) {
    //     return phoneNumber ?? '000';
    //   }
    //   final lastThreeDigits = phoneNumber.substring(phoneNumber.length - 3);
    //   final maskedDigits = '*' * (phoneNumber.length - 3);
    //   return '$maskedDigits$lastThreeDigits';
    // }

    Widget options() {
      return Column(
        children: [
          infoRow('Email', value: _email),
          const Divider(color: Color(0xffb7b7b7)),
          modifyInfoRow("Nama", const changeName(), value: _displayName),
          const Divider(color: Color(0xffb7b7b7)),
          // infoRow("No. Telepon", value: formatPhoneNumber(_phone)),
          // const Divider(color: Color(0xffb7b7b7)),
          modifyInfoRow("Ganti Password", const changePassword())
        ],
      );
    }

    Widget body() {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
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

    return Scaffold(
      backgroundColor: const Color(0xff315EFF),
      appBar: AppBar(
        elevation: 4.0,
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(
          'Detail Profile',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xff315EFF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              picture(),
              body(),
            ],
          ),
        ),
      ),
    );
  }
}
