import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

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
            'assets/images/onboard-1.svg',
            height: size.height * 0.3,
            width: size.width * 0.4,
            // fit: BoxFit.contain,
          ),
        ),
        Expanded(
            //flex: 1,
            child: Column(
          children: [
            Text(
              'All You Need in Your Palm',
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
                'With effortless control,  anytime and anywhere,\n comes great productivity',
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
