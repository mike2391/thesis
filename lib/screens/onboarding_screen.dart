import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intro_screens/intro_page1.dart';
import 'intro_screens/intro_page2.dart';
import 'intro_screens/intro_page3.dart';
import 'intro_screens/intro_page4.dart';
import 'login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 3);
                });
              },
              children: const [
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
                IntroPage4(),
              ],
            ),
            Container(
                alignment: const Alignment(0, 0.95),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //skip
                    onLastPage
                        ? GestureDetector(
                      onTap: () {},
                      child: Text(
                        '       ',
                        style: GoogleFonts.istokWeb(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(3);
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.istokWeb(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    //dot indicator
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: const WormEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          dotColor: Color(0xff5381B2),
                          activeDotColor: Color(0xff001023)),
                    ),

                    //next
                    onLastPage
                    //last page
                        ? GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.istokWeb(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Text(
                        'Next',
                        style: GoogleFonts.istokWeb(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}
