import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ProdukKeuanganScreen extends StatefulWidget {
  const ProdukKeuanganScreen({Key? key}) : super(key: key);

  @override
  _ProdukKeuanganScreenState createState() => _ProdukKeuanganScreenState();
}

class _ProdukKeuanganScreenState extends State<ProdukKeuanganScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Kredit Pinjaman Motor'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Image.asset(
                    'assets/detailProdukKeuangan.png',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'KPM adalah produk pembiayaan sepeda motor dari BCA Multi Finance yang diperuntukkan bagi masyarakat umum, perusahaan, maupun kolektif yang membutuhkan sepeda motor baru. KPM hadir dengan berbagai tenor dan DP yang sesuai dengan kemampuan Anda. KPM memberikan kemudahan bertransaksi dengan bekerjasama dengan Indomaret, Alfamart group, Kantor Pos dan BCA untuk pembayaran angsuran.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }


    Widget ProdukMenu() {
      return Center(
        child: Container(
          width: screenWidth,
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: 140,
                margin: EdgeInsets.all(10),
                child: Card(
                  shadowColor: Colors.grey,
                  color: Color(0xffF0EFEF),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.asset('assets/kpm.png')
                      ),
                      Expanded(
                        flex: 3,
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kredit Pemilikan Motor',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Produk pembiayaan masyarakat yang membutuhkan motor baru',
                                    style: TextStyle(fontSize: 11),
                                  )
                                ],
                              ),
                              Align(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff315EFF),
                                    ),
                                    child: const Text(
                                      'Selengkapnya',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _showDialog();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          'Daftar Produk',
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
              child: ProdukMenu(),
            ),
      ),
    );
  }
}
