import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:dosis_exacta/utils/http_handler.dart';
import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:dosis_exacta/viewmodel/remainder_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart'; // Los temas personalizados

import 'dart:io';


class RemainderPhotoResults extends StatefulWidget {

  final XFile image;
  const RemainderPhotoResults({Key? key, required this.image}) : super(key: key);

  @override
  State<RemainderPhotoResults> createState() => StateRemainderPhotoResults();

}

class StateRemainderPhotoResults extends State<RemainderPhotoResults> {

  bool isLoading = true;
  RemainderVM viewModel = RemainderVM();
  var user;

  // Guarda los medicamentos y regresa
  save() {
    returnMenu();
  }

  // Regresa a la pantalla del menu
  returnMenu() {
    Navigator.of(context).popUntil(ModalRoute.withName("/recordatorio/menu"));
  }

  // Edita los datos
  edit() {
  }

  // Elimina el medicamento
  erase() {
  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {

          var response = await viewModel.uploadPhoto(widget.image);

          if(response.isNotEmpty) {
            Navigator.of(context).pushReplacementNamed("/");
          }
          else {
            setState(
                    () {
                  isLoading = false;
                }
            );
          }

        }
    );

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
        body: SingleChildScrollView( // Contenido de la vista
          child: Column( // Se llena como columna
            crossAxisAlignment: CrossAxisAlignment.center, // Centrado
            mainAxisAlignment: MainAxisAlignment.center, // Centrado
            children: <Widget> [ // Contiene
              SizedBox(height: 0.1.sw), // Espacio en blanco vertical
              Padding( // Contenedor con relleno
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0), // Configura el relleno de los extremos laterales
                child: Image.file(File(widget.image.path)), // Image.asset("assets/images/receta.jpeg"), // Muestra la imagen de la receta
              ),
              SizedBox(height: 0.05.sh),
              Padding( // Contenedor con relleno
                  padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0), // Configura el relleno de los extremos laterales
                  child: Card( // Contenedor de tarjeta
                    elevation: 5, // Sombra
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), // Bordes redondeados
                    child: Padding( // Contenedor con relleno
                        padding: EdgeInsets.fromLTRB(0.05.sw, 0.05.sw, 0.05.sw, 0.05.sw), // Configura el relleno de todos los extremos
                        child: Column( // Se llena como columna
                            crossAxisAlignment: CrossAxisAlignment.start, // Centrado
                            mainAxisAlignment: MainAxisAlignment.center, // Centrado
                            children: <Widget> [ // Contiene
                              Text( // Texto del titulo
                                  "Luvox", // Medicamento
                                  style: AppTextTheme.large(), // Formato de titulo
                                  overflow: TextOverflow.clip // Maneja el desbordamiento
                              ),
                              Text( // Texto de frecuencia
                                  "1 vez al dia", // Frecuencia
                                  style: AppTextTheme.small(color: Colors.grey), // Formato gris
                                  overflow: TextOverflow.clip // Maneja el desbordamiento
                              ),
                              Text( // Texto de indicaciones
                                  "500 mg media tableta por las noches", // Indicaciones
                                  style: AppTextTheme.small(), // Formato del texto
                                  overflow: TextOverflow.clip // Maneja el desbordamiento
                              ),
                              Row( // El panel de los botones
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alineacion homogenea
                                  children: <Widget> [ // Contiene
                                    SizedBox( // Contenedor de tamaño fijo
                                      width: 0.3.sw, // Ancho
                                      child: ElevatedButton( // Boton
                                          onPressed: edit, // Funcion al presionarse
                                          style: Styles.button(context, color: AppColors.accent()), // Color del boton
                                          child: Align( // Alineacion del contenido
                                            alignment: Alignment.center, // Contenido centrado
                                            child: Text( // Texto del boton
                                                "Editar",
                                                style: AppTextTheme.medium(color: Colors.white) // Color del texto
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox( // Contenedor de tamaño fijo
                                      width: 0.3.sw, // Ancho
                                      child: ElevatedButton( // Boton
                                          onPressed: erase, // Funcion al presionarse
                                          style: Styles.button(context, color: AppColors.danger()), // Color del boton
                                          child: Align( // Alineacion del contenido
                                            alignment: Alignment.center, // Contenido centrado
                                            child: Text( // Texto del boton
                                                "Eliminar",
                                                style: AppTextTheme.medium(color: Colors.white) // Color del texto
                                            ),
                                          )
                                      ),
                                    )
                                  ]
                              )
                            ]
                        )
                    ),
                  )
              ),
              SizedBox(height: 0.05.sh),
              Padding( // Contenedor con relleno
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0), // Configura el relleno de los extremos laterales
                child: ElevatedButton( // Agrega un boton al interior
                    onPressed: save, // Funcion que se ejecuta al presionar el boton
                    style: Styles.button(context, color: AppColors.secondary()), // Color del boton
                    child: Row( // El contenido del boton se llena como fila
                      mainAxisAlignment: MainAxisAlignment.center, // Centrado
                      children: <Widget> [ // Contiene
                        Text( // Texto
                            "Guardar",
                            style: AppTextTheme.medium(color: Colors.white) // Formato del texto
                        )
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.05.sh),
              Padding( // Contenedor con relleno
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0), // Configura el relleno de los extremos laterales
                child: ElevatedButton( // Agrega un boton al interior
                    onPressed: returnMenu, // Funcion que se ejecuta al presionar el boton
                    style: Styles.button(context, color: AppColors.primary()), // Estilo del boton
                    child: Row( // El contenido del boton se llena como fila
                      mainAxisAlignment: MainAxisAlignment.center, // Centrado
                      children: <Widget> [ // Contiene
                        Icon(Icons.arrow_back, color: Colors.white, size: 40.sp), // Agrega un icono
                        SizedBox(width: 20.sp), // Espacio en blanco horizontal
                        Text( // Texto
                            "Regresar",
                            style: AppTextTheme.medium(color: Colors.white) // Formato del texto
                        ),
                        SizedBox(width: 25.sp) // Espacio en blanoc
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.1.sw) // Espacio en blanco vertical
            ],
          ),
        )
    );
  }

}
