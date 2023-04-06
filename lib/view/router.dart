import 'package:dosis_exacta/view/contacts/contact_form.dart';
import 'package:dosis_exacta/view/contacts/contact_list.dart';
import 'package:dosis_exacta/view/contacts/contact_menu.dart';
import 'package:dosis_exacta/view/recordatorio/recordatorio_menu.dart';
import 'package:dosis_exacta/view/recordatorio/recordatorio_form.dart';
import 'package:dosis_exacta/view/recordatorio/recordatorio_photo.dart';
import 'package:dosis_exacta/view/recordatorio/remainder_list.dart';
import 'package:dosis_exacta/view/recordatorio/remainder_home.dart';
import 'package:dosis_exacta/view/home.dart';
import 'package:dosis_exacta/view/welcome.dart';

var ROUTER = {
  "/": (context) => Welcome(),
  "/home": (context) => Home(),
  "/contacts/menu": (context) => const ContactMenu(),
  "/contacts/form": (context) => const ContactForm(),
  "/contacts/list": (context) => const ContactList(),
  "/recordatorio/menu": (context) => const RecordatorioMenu(), // Menu
  "/recordatorio/form": (context) => const RecordatorioForm(), // Detalles Medicina
  "/recordatorio/photo": (context) => const RemainderPhoto(), // Tomar Foto
  "/recordatorio/list": (context) => const RemainderList(), // Recordatorios Modificar
  "/recordatorio/home": (context) => const RemainderHome() // Recordatorios
};