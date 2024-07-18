import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pesona2/Approval%20routes/approval_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../repository/repository.dart';
import 'all_news/all_news.dart';
import 'information_detail/news_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  Future<int?>? _approvalCountFuture;
  bool isConnect = false;
  StreamSubscription? _internetConnectionStreamSubscription;
  List<dynamic> _approvalData = [];
  String? _displayName;
  bool isLoading = true;
  Future<List<Map<String, dynamic>>>? _imageUrlsFuture;
  Future<List<Map<String, dynamic>>>? _eventFuture;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
    _approvalCountFuture = DatabaseService().fetchApprovalCount();
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((event) {
      switch (event){
        case InternetStatus.connected:
          setState(() {
            isConnect = true;
            _refreshData();
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnect = false;
            _refreshData();
          });
          break;
        default:
          setState(() {
            _refreshData();
            isConnect = false;
          });
          break;
      }
    });
    getCurrentUser();
    // _loadCarouselImages();
    _imageUrlsFuture = NewsAndEventData().fetchImageUrls();
    _eventFuture = NewsAndEventData().fetchEvent();
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _displayName = user?.displayName;
    });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    final snapshot = await DatabaseService().fetchApprovalSnapshot();
    final imageUrls = await NewsAndEventData().fetchImageUrls();
    final eventUrl = await NewsAndEventData().fetchEvent();
    setState(() {
      getCurrentUser();
      _approvalCountFuture = Future.value(snapshot.length);
      _approvalData = snapshot;
      _imageUrlsFuture = Future.value(imageUrls);
      _eventFuture = Future.value(eventUrl);
    });
  }

  // void _listenForApprovalChanges() {
  //   FirebaseDatabase.instance.ref().child('approval').onChildAdded.listen((event) {
  //     final newApproval = event.snapshot.value;
  //     setState(() {
  //       _approvalData.add(newApproval); // Menambahkan data approval baru ke dalam list yang sudah ada
  //     });
  //     _showNotification('Approval Baru', 'Ada approval baru yang perlu Anda periksa');
  //   });
  // }
  //
  // void _initializeFirebaseMessaging() {
  //   _firebaseMessaging = FirebaseMessaging.instance;
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //
  //     if (notification != null && android != null) {
  //       _showNotification(notification.title, notification.body);
  //     }
  //   });
  //
  //   _firebaseMessaging.subscribeToTopic('approval_notifications');
  // }

  void _initializeDependencies() {
    final NotifPermission notifPermission = NotifPermission();
    notifPermission.declareNotif();
    notifPermission.initializeFirebaseMessaging();
    notifPermission.listenForApprovalChanges((newApproval) {
      setState(() {
        _approvalData.add(newApproval);
      });
      notifPermission.showNotification('Approval Baru', 'Ada approval baru yang perlu Anda periksa');
    });
  }

  @override
  Widget build(BuildContext context) {

    void _showDialog(String title, List<String> contentList) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: contentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${index + 1}. ${contentList[index]}'),
                  );
                },
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

    Widget Welcome(){
      return Container(
        margin: const EdgeInsets.only(top: 50, bottom: 15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _displayName ?? 'User',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget Approval() {
      return FutureBuilder<int?>(
        future: _approvalCountFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final approvalCount = snapshot.data ?? 0;
            if (approvalCount > 0) {
              return Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => ApprovalScreen(approvalData: _approvalData),
                      ),
                    );
                    // Navigator.pushNamed(context, '/approval');
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 0.5,
                          blurRadius: 0.5,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              approvalCount.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Approval yang perlu anda setujui, cek disini sekarang",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text("Tidak ada approval yang tertunda"),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text("Error fetching approval data"),
                ),
              ),
            );
          } else {
            return Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    }

    Widget NewsCarousel() {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _imageUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No carousel images available')),
            );
          } else {
            final imageItems = snapshot.data!;
            return Container(
              margin: const EdgeInsets.only(top:10),
              child: Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: imageItems.length,
                    options: CarouselOptions(
                      height: 180,
                      enlargeCenterPage: true,
                      autoPlay: imageItems.length != 1,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      final item = imageItems[index];
                      final imageUrl = item['imageUrl'];
                      final newsData = item['newsData'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => NewsDetail(arguments: newsData, picture: imageUrl),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  AnimatedSmoothIndicator(
                    activeIndex: currentIndex,
                    count: imageItems.length,
                    effect: const WormEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
    }

    Widget Culture() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18.0, 10.0, 10.0, 10.0),
            child: Text(
              "Budaya Perusahaan",
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff0366B5),
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDialog("SERVE MORE PEOPLE", [
                          "Memberikan pelayanan terbaik bagi pelanggan dan calon pelanggan serta sesama karyawan Perusahaan",
                          "Memberikan solusi yang terbaik dan melebihi kepuasan bagi pelanggan dan calon pelanggan serta sesama karyawan Perusahaan"
                        ]);
                      },
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: const Color(0xff0065B3),
                        ),
                        child: const Center(
                          child: Text(
                            "S",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDialog("MINDSET TO EXCELLENCE", [
                          "Senantiasa meningkatkan kualitas kerja guna memberikan hasil kerja yang memuaskan",
                          "Melakukan perencanaan kerja yang matang",
                          "Melakukan evaluasi dalam setiap pekerjaan",
                          "Melakukan perbaikan berkala dalam setiap pekerjaan",
                          "Memiliki mindset “the winner” yang selalu ingin mencapai lebih dari yang diminta Perusahaan"
                        ]);
                      },
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: const Color(0xffED2124),
                        ),
                        child: const Center(
                          child: Text(
                            "M",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDialog("ACT WITH INTEGRITY", [
                          "Jujur dalam berpikir dan bertindak",
                          "Bebas dari pengaruh dan keinginan memanipulasi",
                          "Disiplin dan bertanggungjawab dalam setiap pekerjaan",
                          "Mengambil keputusan dalam pekerjaan secara obyektif, bukan berdasarkan kepentingan atau pilihan pribadi",
                          "Bertindak sesuai ketentuan yang berlaku",
                          "Memiliki nilai dasar yang menolak dan memusuhi segala jenis Korupsi, Kolusi, Nepotisme (KKN) dan kegiatan-kegiatan yang"
                              " melanggar norma-norma dan ketentuan perundang-undangan yang berlaku"
                        ]);
                      },
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: const Color(0xffFDB813),
                        ),
                        child: const Center(
                          child: Text(
                            "A",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDialog("RESPECT AND CARE", [
                          "Melandasi semangat kerja tinggi dengan rasa bangga dan rasa memiliki Perusahaan",
                          "Menciptakan kerjasama dan hubungan yang tulus untuk mencapai hasil terbaik bagi Perusahan",
                          "Memberikan kepedulian dan bantuan terbaik kepada sesama anggota tim",
                          "Menghargai perbedaan pendapat antar sesama anggota tim atau unit kerja lain",
                          "Menghormati harkat dan martabat sesama anggota tim atau unit kerja lain dengan menerapkan rasa hormat dalam komunikasi dan interaksi kerja"
                        ]);
                      },
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: const Color(0xff00B0AD),
                        ),
                        child: const Center(
                          child: Text(
                            "R",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDialog("TOUGH MENTALITY", [
                          "Ketangguhan yang cerdas untuk meraih hasil melampaui target",
                          "Keteguhan untuk selalu menjadi yang terbaik",
                          "Memiliki mental yang tidak mudah patah semangat dan selalu ingin mencapai yang lebih dibanding umumnya"
                        ]);
                      },
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: const Color(0xff0065B3),
                        ),
                        child: const Center(
                          child: Text(
                            "T",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Widget LatestEvent() {
    //   return FutureBuilder<List<Map<String, dynamic>>>(
    //     future: _eventFuture,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Padding(
    //           padding: EdgeInsets.symmetric(vertical: 20),
    //           child: Center(child: CircularProgressIndicator()),
    //         );
    //       } else if (snapshot.hasError) {
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 20),
    //           child: Center(child: Text('Error: ${snapshot.error}')),
    //         );
    //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //         return const Padding(
    //           padding: EdgeInsets.symmetric(vertical: 20),
    //           child: Center(child: Text('No events found')),
    //         );
    //       } else {
    //         List<Map<String, dynamic>> events = snapshot.data!;
    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const Padding(
    //               padding: EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 0.0),
    //               child: Text(
    //                 "Event Perusahaan",
    //                 style: TextStyle(
    //                   color: Color(0xff0366B5),
    //                   fontSize: 14,
    //                   fontWeight: FontWeight.w600,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
    //               child: SizedBox(
    //                 height: 180,
    //                 child: ListView.builder(
    //                   scrollDirection: Axis.horizontal,
    //                   itemCount: events.length,
    //                   itemBuilder: (context, index) {
    //                     final event = events[index];
    //                     final imageUrl = event['imageUrl'];
    //                     final eventData = event['eventData'];
    //                     return Padding(
    //                       padding: const EdgeInsets.only(right: 8.0),
    //                       child: GestureDetector(
    //                         onTap: (){
    //                           Navigator.of(context, rootNavigator: true).push(
    //                             MaterialPageRoute(
    //                               builder: (context) => NewsDetail(arguments: eventData, picture: imageUrl),
    //                             ),
    //                           );
    //                         },
    //                         child: Container(
    //                           width: 120.0,
    //                           decoration: BoxDecoration(
    //                             image: DecorationImage(
    //                               image: NetworkImage(imageUrl),
    //                               fit: BoxFit.cover,
    //                             ),
    //                             borderRadius: BorderRadius.circular(16.0),
    //                             color: Colors.grey,
    //                           ),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       }
    //     },
    //   );
    // }

    Widget LatestEvent() {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          } else {
            List<Map<String, dynamic>> events = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 0.0),
                  child: Text(
                    "Event Perusahaan",
                    style: TextStyle(
                      color: Color(0xff0366B5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final imageUrl = event['imageUrl'];
                        final eventData = event['eventData'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => NewsDetail(arguments: eventData, picture: imageUrl),
                                ),
                              );
                            },
                            child: Container(
                              width: 120.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      );
    }

    Widget LatestNews() {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _imageUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No carousel images available')),
            );
          } else {
            final imageItems = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Berita Terkini",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff0366B5),
                            fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => AllNews(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xff0366B5),
                          minimumSize: const Size(50.0, 28.0),
                        ),
                        child: const Text("See All"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
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
                ),
              ],
            );
          }
        },
      );
    }

    Widget LostConnection(){
      return Center(
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 0.5,
                blurRadius: 0.5,
              ),
            ],
            color: Colors.white,
          ),
          child: const Center(
            child: Text("Tidak ada internet"),
          ),
        ),
      );
    }

    // Widget Body(){
    //   return Container(
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //     padding: const EdgeInsets.only(top: 10, bottom: 171), // Adjusted padding here
    //     decoration: const BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(10),
    //         topRight: Radius.circular(10),
    //       ),
    //     ),
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           isConnect? Approval() : LostConnection(),
    //           NewsCarousel(),
    //           Culture(),
    //           LatestEvent(),
    //           LatestNews(),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    Widget Body() {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventFuture,
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 10, bottom: 171), // Adjusted padding here
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isConnect ? Approval() : LostConnection(),
                  NewsCarousel(),
                  Culture(),
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) LatestEvent(),
                  LatestNews(),
                ],
              ),
            ),
          );
        },
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xff315EFF),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            children: [
              Welcome(),
              Body(),
            ],
          ),
        ),
      ),
    );
  }
}