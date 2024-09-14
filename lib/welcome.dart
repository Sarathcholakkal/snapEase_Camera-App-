import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:snap_app/snap_taker.dart';

class WelcomeScreen extends StatelessWidget {
  final List<CameraDescription> camera;
  const WelcomeScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 120),
                  child: Text(
                    " Welcome to SnapEase",
                    style: GoogleFonts.montserrat(
                        fontSize: 24,
                        color: const Color(0xFF252525),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 90, left: 50),
                    child: Image.asset(
                        width: 300, height: 155, 'asset/picture.png')),
                Container(
                  margin: EdgeInsets.only(top: 60, left: 20),
                  child: Text(
                    " Capture your moments with ease! Ready to explore and snap stunning photos? Let's get started!",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: const Color(0xFF252525),
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(top: 50, left: 50),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => SnapTaker(camera: camera),
                        ),
                      );
                    },
                    child: const Text(
                      "Launch Camera",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
