import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snap_app/detailed_view.dart';

class Gallery extends StatelessWidget {
  final List<File> imageFileList;

  const Gallery({
    super.key,
    required this.imageFileList,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF6C63FF),
            title: const Text(
              "Gallery",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: const Color(0xFF9292FD),
          body: GridView.builder(
            itemCount: imageFileList.length,
            itemBuilder: (ctx, index) {
              final snap = imageFileList[index];

              return GestureDetector(
                onDoubleTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return DetailedView(
                          snap: snap,
                        );
                      },
                    ),
                  );
                },
                child: Card(
                  shadowColor: Color.fromARGB(211, 3, 3, 231),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(color: Colors.white),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Image(
                      height: 200,
                      width: 200,
                      image: FileImage(
                        File(imageFileList[index].path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            padding: const EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }
}
