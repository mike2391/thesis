import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetail extends StatelessWidget {
  final Map<String, dynamic> arguments;
  final String picture;

  const NewsDetail({super.key, required this.arguments, required this.picture});
  @override
  Widget build(BuildContext context) {
    String formatDate(String date, {String format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"}) {
      try {
        return DateFormat('dd MMMM yyyy').format(DateFormat(format).parse(date));
      } catch (e) {
        return 'Invalid date';
      }
    }

    Widget Details() {
      return Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                arguments['title'],  // Mengubah 'arguments['title']' menjadi widget Text
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.network(picture),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (arguments.containsKey('date_created'))
                    Text(
                      'Dibuat: ${formatDate(arguments['date_created'])}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xff777777)
                      ),
                    ),
                  if (arguments.containsKey('startDate') && arguments.containsKey('endDate')) ...[
                    Text(
                      'Mulai: ${formatDate(arguments['startDate'], format: 'MM/dd/yyyy')}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xff777777)
                      ),
                    ),
                    Text(
                      'Berakhir: ${formatDate(arguments['endDate'], format: 'MM/dd/yyyy')}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xff777777)
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Html(
                data: arguments['description'],
                style: {
                  "body": Style(
                    fontSize: FontSize(15.0), // Set the desired font size here
                  ),
                },
              ),
            ),
          ],
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
          'Detail Berita',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xff315EFF),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Details(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
