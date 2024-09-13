import 'dart:io';

import 'package:flutter/material.dart';

class DetailedView extends StatelessWidget {
  final File snap;

  DetailedView({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: GestureDetector(
          onDoubleTap: () => Navigator.of(context).pop(),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: Image(
              height: 400,
              width: 400,
              image: FileImage(
                File(snap.path),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
