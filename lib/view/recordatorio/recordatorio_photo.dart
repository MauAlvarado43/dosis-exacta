import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Scaffold() : Scaffold(
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
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
