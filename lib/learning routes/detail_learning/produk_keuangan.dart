import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class ProdukKeuanganScreen extends StatefulWidget {
  const ProdukKeuanganScreen({Key? key}) : super(key: key);

  @override
  _ProdukKeuanganScreenState createState() => _ProdukKeuanganScreenState();
}

class _ProdukKeuanganScreenState extends State<ProdukKeuanganScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://drive.google.com/uc?export=download&id=1ZsBEnMZitKgLSMC9jnXMXf9WT-N8xbMI'));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

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
              child: SingleChildScrollView( // Tambahkan ini untuk membuat teks bisa di-scroll
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // Video player siap ditampilkan
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                VideoPlayer(_controller),
                                _ControlsOverlay(controller: _controller),
                                VideoProgressIndicator(_controller, allowScrubbing: true),
                              ],
                            ),
                          );
                        } else {
                          // Tampilkan animasi progress bar di bawah saat video loading
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio, // Tentukan aspect ratio agar konsisten
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              color: Colors.black,
                              child: const LinearProgressIndicator(
                                  color: Color(0xffD4282B)
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'KPM adalah produk pembiayaan sepeda motor dari BCA Multi Finance yang diperuntukkan bagi masyarakat umum, perusahaan, maupun kolektif yang membutuhkan sepeda motor baru. KPM hadir dengan berbagai tenor dan DP yang sesuai dengan kemampuan Anda. KPM memberikan kemudahan bertransaksi dengan bekerjasama dengan Indomaret, Alfamart group, Kantor Pos dan BCA untuk pembayaran angsuran.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
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

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, VideoPlayerValue value, child){
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              reverseDuration: const Duration(milliseconds: 200),
              child: controller.value.isPlaying
                  ? const SizedBox.shrink()
                  : const ColoredBox(
                color: Colors.black26,
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 100.0,
                    semanticLabel: 'Play',
                  ),
                ),
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}