import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/onboard_service.dart';
import '../widgets/page.three.dart';
import '../widgets/page_one.dart';
import '../widgets/page_two.dart';
import 'landing_page.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final PageController _controller = PageController();
  bool isLastIndex = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(0),
      //   child: SizedBox.shrink(),
      // ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: _controller,
          onPageChanged: (value) {
            setState(() => isLastIndex = value == 2);
          },
          children: const [
            PageOne(),
            PageTwo(),
            PageThree(),
          ],
        ),
      ),
      bottomSheet: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height * 0.20,
          maxHeight: size.height * 0.20,
          minWidth: size.width,
        ),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 30),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLastIndex
                  ? FilledButton(
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LandingPage(),
                            ),
                            (route) => route.isFirst);
                        OnboardService.toggleShowHome(true);
                        // _controller.jumpToPage(0);
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                      ),
                      child: const Text(
                        "Get Started",
                      ),
                    )
                  : FilledButton(
                      onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                      ),
                      child: const Text(
                        'Next',
                      ),
                    ),
              const Expanded(
                child: SizedBox(
                  height: 40,
                ),
              ),
              Expanded(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    radius: 10,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 20,
                    dotColor: Theme.of(context).colorScheme.inversePrimary,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
