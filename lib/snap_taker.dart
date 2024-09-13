import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';

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

    if (file != null) {
      print("file not null here");
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: takePicture,
        backgroundColor: Colors.white38,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.camera_alt,
          size: 47,
          color: Colors.black,
        ),
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
                    padding: EdgeInsets.only(bottom: 80),
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
