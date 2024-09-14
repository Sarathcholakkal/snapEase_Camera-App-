import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:snap_app/gallery.dart';

class SnapTaker extends StatefulWidget {
  final List<CameraDescription> camera;

  const SnapTaker({super.key, required this.camera});

  @override
  State<SnapTaker> createState() => _SnapTakerState();
}

class _SnapTakerState extends State<SnapTaker> {
  late CameraController cameracontroller;
  late Future<void> cameraValue;
  List<File> imageFileList = [];

  //!==============start camera======================================
  void startCamera(int cameraType) {
    cameracontroller = CameraController(
        widget.camera[cameraType], ResolutionPreset.max,
        enableAudio: false);
    cameraValue = cameracontroller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError(
      (Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              break;
            default:
              break;
          }
        }
      },
    );
  }

  //?===============take picture =======================================

  void takePicture() async {
    XFile? image;
    if (cameracontroller.value.isTakingPicture ||
        !cameracontroller.value.isInitialized) {
      return;
    }

    image = await cameracontroller.takePicture();

    final file = await saveImage(image);

    // if (file != null) {
    //   print("file not null here");
    // }
    setState(() {
      imageFileList.add(file);
    });

    // MediaScanner.loadMedia(path: file.path);
  }

  //============save image===================================

  Future<File> saveImage(XFile image) async {
    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
    final file = File('$downloadPath/$fileName');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (_) {}
    return file;
  }

  @override
  void initState() {
    super.initState();
    startCamera(0);
  }

  // @override
  // void dispose() {
  //   cameraValue.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!cameracontroller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: const Color(0xFF9292FD), width: .4),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 40,
                color: Color(0xFF6C63FF),
              ),
            ),
          ),
          // SizedBox()
          FloatingActionButton(
            onPressed: takePicture,
            backgroundColor: const Color(0xFF9292FD),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.camera_alt,
              size: 47,
              color: Color(0xFF6C63FF),
            ),
          ),
          // const SizedBox(
          //   width: 90,
          // ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return Gallery(imageFileList: imageFileList);
                  },
                ),
              );
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: const Color(0xFF9292FD), width: .4),
              ),
              child: const Icon(
                Icons.photo_library_rounded,
                size: 40,
                color: Color(0xFF6C63FF),
              ),
            ),
          ),
          // const SizedBox(
          //   width: 30,
          // )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: CameraPreview(cameracontroller),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: imageFileList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: Image(
                                height: 100,
                                width: 100,
                                image: FileImage(
                                  File(imageFileList[index].path),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
