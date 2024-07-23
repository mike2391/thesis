// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../learning routes/keuangan.dart';
// // import '../learning_routes/keuangan.dart';
//
// class Learning extends StatefulWidget {
//   const Learning({super.key});
//
//   @override
//   State<Learning> createState() => _LearningState();
// }
//
// class _LearningState extends State<Learning> {
//   @override
//   Widget build(BuildContext context) {
//     Widget menuLearning() {
//       return Container(
//         margin: const EdgeInsets.only(top: 20),
//         child: Center(
//           child: Wrap(
//             spacing: 16,
//             runSpacing: 16,
//             children: [
//               _buildMenuItem(
//                 context,
//                 'Keuangan',
//                 'assets/keuangan.png',
//                 const LearningKeuanganScreen(),
//               ),
//               // _buildMenuItem(
//               //   context,
//               //   'Operasional',
//               //   'assets/operasional.png',
//               //   const LearningKeuanganScreen(), // Replace with appropriate screen
//               // ),
//               // _buildMenuItem(
//               //   context,
//               //   'Penagihan',
//               //   'assets/penagihan.png',
//               //   const LearningKeuanganScreen(), // Replace with appropriate screen
//               // ),
//               // _buildMenuItem(
//               //   context,
//               //   'Risiko & Kepatuhan',
//               //   'assets/resiko.png',
//               //   const LearningKeuanganScreen(), // Replace with appropriate screen
//               // ),
//               // _buildMenuItem(
//               //   context,
//               //   'Penjualan',
//               //   'assets/penjualan.png',
//               //   const LearningKeuanganScreen(), // Replace with appropriate screen
//               // ),
//               // _buildMenuItem(
//               //   context,
//               //   'IT & Bispro',
//               //   'assets/itbispro.png',
//               //   const LearningKeuanganScreen(), // Replace with appropriate screen
//               // ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Learning',
//           style: GoogleFonts.montserrat(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xff315EFF),
//       ),
//       body: Column(
//         children: [
//           menuLearning(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(BuildContext context, String title, String imagePath, Widget destination) {
//     return SizedBox(
//       width: (MediaQuery.of(context).size.width - 64) / 2,
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Container(
//           height: 150,
//           width: 150,
//           decoration: BoxDecoration(
//             color: const Color(0xffF0EFEF),
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 spreadRadius: 0.4,
//                 blurRadius: 1,
//                 offset: const Offset(0, 2),
//               )
//             ],
//           ),
//           child: MaterialButton(
//             onPressed: () {
//               Navigator.of(context, rootNavigator: true).push(
//                 MaterialPageRoute(
//                   builder: (context) => destination,
//                 ),
//               );
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(imagePath, width: 90, height: 90),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
