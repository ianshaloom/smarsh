import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePageTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String svg;
  final String role;
  const HomePageTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.svg,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          (title == 'Non-Posted') ? onTap(context) : onTap(context, role),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          //height: 115,
          //width: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(svg, height: 100, width: 70),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
