import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class IntroKeuanganScreen extends StatefulWidget {
  const IntroKeuanganScreen({Key? key}) : super(key: key);

  @override
  _IntroKeuanganScreenState createState() => _IntroKeuanganScreenState();
}

class _IntroKeuanganScreenState extends State<IntroKeuanganScreen> {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget BodyDetailIntroduction() {
      return Container(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'Introduction',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 5),
              child: Text(
                'Divisi keuangan dalam sebuah perusahaan adalah salah satu bagian yang paling krusial dan integral dalam struktur organisasi. Tugas utama dari divisi ini adalah mengelola segala aspek keuangan perusahaan, termasuk perencanaan, pengendalian, dan pengawasan arus kas, serta memastikan bahwa perusahaan memiliki sumber daya yang cukup untuk mendukung operasionalnya dan mencapai tujuannya.',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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
          'Divisi Keuangan Keuangan',
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
          child: BodyDetailIntroduction(),
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
