import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ApprovalScreen(
        approvalData: ModalRoute.of(context)!.settings.arguments as List<dynamic>,
      ),
    );
  }
}

class ApprovalScreen extends StatelessWidget {
  final List<dynamic> approvalData;
  const ApprovalScreen({super.key, required this.approvalData});

  Widget Approval() {
    return ListView.builder(
      itemCount: approvalData.length,
      itemBuilder: (context, index) {
        final approvalItem = approvalData[index];
        final title = approvalItem['title'];
          return Card(
            child: ListTile(
              title: Text(title),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Approval',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xff315EFF),
      ),
      body: Approval(),
    );
  }
}
