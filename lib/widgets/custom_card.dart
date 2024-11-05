import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class CustomCard extends StatelessWidget {
  final String tileText;
  final String iconPath;
  final VoidCallback onTap;
  const CustomCard({super.key, required this.tileText, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          height: 80,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              width: 80, // Set a fixed width for each item
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    iconPath,
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(width: 10),
                  AutoSizeText(
                    tileText,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
