import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroKeuanganScreen extends StatefulWidget {
  const IntroKeuanganScreen({Key? key}) : super(key: key);

  @override
  _IntroKeuanganScreenState createState() =>
      _IntroKeuanganScreenState();
}

class _IntroKeuanganScreenState
    extends State<IntroKeuanganScreen> {
  @override
  Widget build(BuildContext context) {

    Widget BodyDetailIntroduction() {
      return Container(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'Introduction',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Image.asset(
              "assets/videointroduction.jpg",
              width: 380,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 5),
              child: Text(
                'Divisi keuangan dalam sebuah perusahaan adalah salah satu bagian yang paling krusial dan integral dalam struktur organisasi. Tugas utama dari divisi ini adalah mengelola segala aspek keuangan perusahaan, termasuk perencanaan, pengendalian, dan pengawasan arus kas, serta memastikan bahwa perusahaan memiliki sumber daya yang cukup untuk mendukung operasionalnya dan mencapai tujuannya.',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Instruksi Keuangan',
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
          child: BodyDetailIntroduction(),
        )
      )
    );
  }
}
