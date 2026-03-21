import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String caption;

  const AuthHeader({
    required this.title,
    required this.subtitle,
    required this.caption,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        SizedBox(height: 8),
        Text(subtitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        Text(caption, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
