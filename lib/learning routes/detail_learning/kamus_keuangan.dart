import 'package:flutter/material.dart';
import 'package:custom_accordion/custom_accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class KamusKeuanganScreen extends StatefulWidget {
  const KamusKeuanganScreen({Key? key}) : super(key: key);

  @override
  _KamusKeuanganScreenState createState() => _KamusKeuanganScreenState();
}

class _KamusKeuanganScreenState extends State<KamusKeuanganScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget KamusDropdown() {
      return Container(
        width: screenWidth * 1,
        margin: EdgeInsets.only(top: 10, left: 25, right: 25),
        child: Column(
          children: [
            CustomAccordion(
              title: 'PPh',
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
              widgetItems: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'PPh atau Pajak Penghasilan adalah pajak yang dikenakan kepada orang pribadi atau badan atas penghasilan yang diterima atau diperoleh dalam suatu tahun pajak.',
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
            CustomAccordion(
              title: 'PPN',
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
              widgetItems: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'PPN atau Pajak Pertambahan Nilai adalah pajak yang disetor dan dilaporkan pihak penjual yang telah dikukuhkan sebagai Pengusaha Kena Pajak (PKP). Batas waktu penyetoran dan pelaporan PPN adalah setiap akhir bulan',
                    style: TextStyle(),
                  ),
                ],
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
          'Kamus Keuangan',
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
          child: KamusDropdown(),
        ),
      ),
    );
  }
}
