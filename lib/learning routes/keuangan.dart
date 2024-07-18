import 'package:flutter/material.dart';
import 'package:custom_accordion/custom_accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesona2/learning%20routes/detail_learning/kamus_keuangan.dart';
import 'detail_learning/instruksi_keuangan.dart';
import 'detail_learning/produk_keuangan.dart';

class LearningKeuanganScreen extends StatefulWidget {
  const LearningKeuanganScreen({super.key});

  @override
  _LearningKeuanganScreenState createState() => _LearningKeuanganScreenState();
}

class _LearningKeuanganScreenState extends State<LearningKeuanganScreen> {
  @override
  Widget build(BuildContext context) {
    Widget KnowledgeMenu() {
      return Container(
        margin: const EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: CustomAccordion(
                title: 'Knowledge',
                headerBackgroundColor: const Color(0xffF0EFEF),
                titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                toggleIconOpen: Icons.keyboard_arrow_down_sharp,
                toggleIconClose: Icons.keyboard_arrow_up_sharp,
                headerIconColor: Colors.grey,
                accordionElevation: 2,
                backgroundColor: const Color(0xffF0EFEF),
                widgetItems: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => const ProdukKeuanganScreen(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          WidgetStateProperty.all(Color(0xff315EFF))),
                      child: const Text(
                        'Sosialisasi Produk',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => const KamusKeuanganScreen(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          WidgetStateProperty.all(Color(0xff315EFF))),
                      child: const Text(
                        'Kamus Perusahaan',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: CustomAccordion(
                title: 'Instruction',
                headerBackgroundColor: Color(0xffF0EFEF),
                titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                toggleIconOpen: Icons.keyboard_arrow_down_sharp,
                toggleIconClose: Icons.keyboard_arrow_up_sharp,
                headerIconColor: Colors.grey,
                accordionElevation: 2,
                backgroundColor: Color(0xffF0EFEF),
                widgetItems: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => const InstruksiKeuanganScreen(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          WidgetStateProperty.all(Color(0xff315EFF))),
                      child: const Text(
                        'Instruksi Kerja',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
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
        title: Text(

          'Keuangan',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xff315EFF),
      ),
      body:Container(
            child: KnowledgeMenu(),
      ),
    );
  }
}
