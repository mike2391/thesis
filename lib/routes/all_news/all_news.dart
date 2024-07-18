import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../repository/repository.dart';
import '../information_detail/news_detail.dart';

class AllNews extends StatefulWidget {
  const AllNews({super.key});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {

  Future<List<Map<String, dynamic>>>? _imageUrlsFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlsFuture = NewsAndEventData().fetchImageUrls();
  }

  Future<void> _refreshData() async {
    final imageUrls = await NewsAndEventData().fetchImageUrls();
    setState(() {
      _imageUrlsFuture = Future.value(imageUrls);
    });
  }

  Widget AllNews() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _imageUrlsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No carousel images available'));
        } else {
          final imageItems = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: imageItems.length,
              itemBuilder: (context, index) {
                final item = imageItems[index];
                final imageUrl = item['imageUrl'];
                final newsData = item['newsData'];
                final newsTitle = newsData['title'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => NewsDetail(arguments: newsData, picture: imageUrl),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.33,
                              decoration: const BoxDecoration(color: Colors.blue),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                width: 0.67 * MediaQuery.of(context).size.width,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    newsTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Semua Berita',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xff315EFF),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: _refreshData,
            child: AllNews()
        ),
      ),
    );
  }
}
