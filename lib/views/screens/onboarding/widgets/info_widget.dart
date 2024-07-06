import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'The world\'s ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB2B2B2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'fastest ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA2A2A2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'messaging app.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB2B2B2),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'It is ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB2B2B2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'free ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA2A2A2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'and ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB2B2B2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'secure',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA2A2A2),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
