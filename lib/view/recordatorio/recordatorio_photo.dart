import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:dosis_exacta/view/recordatorio/recordatorio_photo_resultados.dart';
import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';

import '../common/theme.dart';

class RemainderPhoto extends StatefulWidget {
  const RemainderPhoto({Key? key}) : super(key: key);

  @override
  State<RemainderPhoto> createState() => StateRemainderPhoto();
}

class StateRemainderPhoto extends State<RemainderPhoto> {

  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  bool flash = false;
  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;

  late CameraController controller;
  late Future<void> initializeControllerFuture;

  late XFile? imageFile; // Variable para almacenar la imagen

  StateRemainderPhoto() {
    initializeCamera();
  }

  returnMenu() {
    Navigator.of(context).pop();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);
    initializeControllerFuture = controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) async {
        user = await viewModel.checkExistingUser();
        if(user == null) {
          Navigator.of(context).pushReplacementNamed("/");
        }
        else {
          setState(
                  () {
                isLoading = false;
              }
          );
          initializeCamera();
        }
      }
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery
          .of(context)
          .size
          .width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await controller.setFocusPoint(point);

      // Manually set light exposure
      //controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold() : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(
              "Fotografia",
              style: AppTextTheme.medium(color: Colors.white)
            )
          ],
        ),
      ),
      body: FadeIn(child: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTapUp: (details) {
                _onTap(details);
              },
              child: Stack(
                children: [
                  CameraPreview(controller),
                  showFocusCircle ? Positioned(
                    top: y - 20,
                    left: x - 20,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white,width: 2)
                      ),
                    )) : SizedBox(),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.secondary(),
            onPressed: () async {
              setState(() {
                flash = !flash;
                controller.setFlashMode(flash ? FlashMode.torch : FlashMode.off);
              });
            },
            child: flash ? Icon(Icons.lightbulb) : Icon(Icons.lightbulb_outline),
          ),
          const SizedBox(width: 15,),
          FloatingActionButton(
            backgroundColor: AppColors.primary(),
            onPressed: () async {
              try {
                await initializeControllerFuture;
                final image = await controller.takePicture(); // Toma la fotografia
                if (!mounted) return;
                setState(() {
                  imageFile = XFile(image.path); // Asigna la imagen a la variable
                });
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RemainderPhotoResults(
                      image: image,
                    ),
                  ),
                );
                Navigator.of(context).pop();
              } catch (e) {
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          )
        ],
    ),
    );
  }

}
