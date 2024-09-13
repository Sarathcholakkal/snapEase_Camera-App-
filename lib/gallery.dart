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
      child: GridView.builder(
        itemCount: imageFileList.length,
        itemBuilder: (ctx, index) {
          final snap = imageFileList[index];

          return GestureDetector(
            onDoubleTap: () {
              // Navigator.of(ctx).push(
              //   MaterialPageRoute(
              //     builder: (context) =>

              //   ),
              // );
            },
            child: GestureDetector(
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
    );
  }
}
