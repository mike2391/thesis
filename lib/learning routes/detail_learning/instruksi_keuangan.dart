import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'intro_keuangan.dart';

class InstruksiKeuanganScreen extends StatefulWidget {
  const InstruksiKeuanganScreen({Key? key}) : super(key: key);

  @override
  _InstruksiKeuanganScreenState createState() =>
      _InstruksiKeuanganScreenState();
}

class _InstruksiKeuanganScreenState extends State<InstruksiKeuanganScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget BodyInstruksiKerja() {
      return Container(
        width: screenWidth,
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Container(
                    height: 200,
                    width: 165,
                    decoration: BoxDecoration(
                      color: const Color(0xffF0EFEF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0.4,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        Image.asset('assets/keuangan.png',
                            width: 90, height: 90),
                        const Text(
                          'Introduction',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => const IntroKeuanganScreen(),
                              ),
                            );
                          },
                          child: Text('Detail',style: TextStyle(color: Colors.white),),
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all(Color(0xff315EFF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 90, left: 10, right: 10),
                //   child: Container(
                //     height: 200,
                //     width: 165,
                //     decoration: BoxDecoration(
                //       color: Color(0xffF0EFEF),
                //       borderRadius: BorderRadius.circular(20),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.3),
                //           spreadRadius: 0.4,
                //           blurRadius: 1,
                //           offset: const Offset(0, 2),
                //         ),
                //       ],
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset('assets/keuangan.png',
                //             width: 90, height: 90),
                //         Text(
                //           'Peraturan Perusahaan',
                //           textAlign: TextAlign.center,
                //         ),
                //         SizedBox(height: 5),
                //         ElevatedButton(
                //           onPressed: () {},
                //           child: Text('Detail'),
                //           style: ButtonStyle(
                //             backgroundColor:
                //             MaterialStateProperty.all(Color(0xff7da0ca)),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.all(10),
            //       child: Container(
            //         height: 200,
            //         width: 165,
            //         decoration: BoxDecoration(
            //           color: Color(0xffF0EFEF),
            //           borderRadius: BorderRadius.circular(20),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.3),
            //               spreadRadius: 0.4,
            //               blurRadius: 1,
            //               offset: const Offset(0, 2),
            //             ),
            //           ],
            //         ),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset('assets/keuangan.png',
            //                 width: 90, height: 90),
            //             Text(
            //               'ESS',
            //               textAlign: TextAlign.center,
            //             ),
            //             SizedBox(height: 5),
            //             ElevatedButton(
            //               onPressed: () {},
            //               child: Text('Detail'),
            //               style: ButtonStyle(
            //                 backgroundColor:
            //                 WidgetStateProperty.all(Color(0xff7da0ca)),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.all(10),
            //       child: Container(
            //         height: 200,
            //         width: 165,
            //         decoration: BoxDecoration(
            //           color: Color(0xffF0EFEF),
            //           borderRadius: BorderRadius.circular(20),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.3),
            //               spreadRadius: 0.4,
            //               blurRadius: 1,
            //               offset: const Offset(0, 2),
            //             ),
            //           ],
            //         ),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset('assets/keuangan.png',
            //                 width: 90, height: 90),
            //             Text(
            //               'Silvi',
            //               textAlign: TextAlign.center,
            //             ),
            //             SizedBox(height: 5),
            //             ElevatedButton(
            //               onPressed: () {},
            //               child: Text('Detail'),
            //               style: ButtonStyle(
            //                 backgroundColor:
            //                 MaterialStateProperty.all(Color(0xff7da0ca)),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
        child: BodyInstruksiKerja(),
      ),
    );
  }
}
