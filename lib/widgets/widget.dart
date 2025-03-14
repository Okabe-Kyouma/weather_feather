import 'package:flutter/material.dart';

Widget BrandName() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Wally',
        style: TextStyle(color: Colors.black87),
      ),
      Text(
        'Pep',
        style: TextStyle(color: Colors.blue),
      )
    ],
  );
}
