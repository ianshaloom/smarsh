import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: SvgPicture.asset(
            'assets/images/onboard-2.svg',
            height: size.height * 0.3,
            width: size.width * 0.4,
          ),
        ),
        Expanded(
            //flex: 1,
            child: Column(
          children: [
            Text(
              'Secure and Reliable',
              style: textTheme.bodyLarge!.copyWith(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Your data is safe with us, we have got you covered',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge!.copyWith(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }
}
