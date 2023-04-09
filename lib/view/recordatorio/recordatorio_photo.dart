import 'dart:ui';

import 'package:dosis_exacta/view/recordatorio/recordatorio_photo_resultados.dart';
import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart'; // Los temas personalizados

import 'package:camera/camera.dart'; // Para el manejo de la camara

class RemainderPhoto extends StatefulWidget {
  const RemainderPhoto({Key? key}) : super(key: key);

  @override
  State<RemainderPhoto> createState() => StateRemainderPhoto();
}

class StateRemainderPhoto extends State<RemainderPhoto> {
  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;

  late CameraController controller; // Para controlar la camara
  late Future<void> initializeControllerFuture; // Para inicializar la camara

  // Regresa a la pantalla anterior
  returnMenu() {
    Navigator.of(context).pop();
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

  Future<void> initializeCamera() async {
    final cameras = await availableCameras(); // Obtiene una lista de las cámaras disponibles en el dispositivo.
    final firstCamera = cameras.first;   // Obtiene una cámara específica de la lista de cámaras disponibles
    controller = CameraController(firstCamera, ResolutionPreset.medium); // Crea el controlador de la camara
    initializeControllerFuture = controller.initialize(); // Inicializa el controlador
  }

  @override
  void dispose() {
    controller.dispose(); // Destruccion del controlador
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return isLoading ? const Scaffold() : Scaffold(
        appBar: AppBar( // La barra de titulo
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary(), // Color de fondo
          title: Row( // Seccion del titulo se llena en fila
            mainAxisAlignment: MainAxisAlignment.center, // Centrado horizontalmente
            children: <Widget> [ // Contiene
              Text( // Texto
                  "Fotografia", // Cadena de contenido
                  style: AppTextTheme.medium(color: Colors.white) // Formato color blanco
              )
            ],
          ),
        ),
        body: FutureBuilder<void>( // Constructor de un evento futuro
          future: initializeControllerFuture, // El evento futuro es la inicializacion de la camara
          builder: (context, snapshot) { // Constructor anonimo
            if (snapshot.connectionState == ConnectionState.done) { // Si el Future está completo
              return CameraPreview(controller); // muestra la vista previa
            } else { // Si aun no se inicializa
              return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga
            }
          },
        ),
      floatingActionButton: FloatingActionButton( // Boton camara
        onPressed: () async { // Funcion anonima para tomar la fotografia
          try { // Intenta
            await initializeControllerFuture; // Esperar a que se inicialice la camara
            final image = await controller.takePicture(); // Tomar la fotografia
            if (!mounted) return; // Al ser asincrono si ya no esta activo el widget termina
            await Navigator.of(context).push( // Muestra la siguiente pantalla
              MaterialPageRoute( // Crea la pantalla
                builder: (context) => RemainderPhotoResults( // Construye el widget
                  imagePath: image.path, // Le envia la ruta de la imagen
                ),
              ),
            );
          } catch (e) { // Si ocurre un error
            print(e); // Lo muestra en la consola
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

}
