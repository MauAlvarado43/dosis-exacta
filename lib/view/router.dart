import 'package:dosis_exacta/view/contacts/contact_form.dart';
import 'package:dosis_exacta/view/contacts/contact_menu.dart';
import 'package:dosis_exacta/view/home.dart';
import 'package:dosis_exacta/view/welcome.dart';

var ROUTER = {
  "/": (context) => Welcome(),
  "/home": (context) => Home(),
  "/contacts/menu": (context) => ContactMenu(),
  "/contacts/form": (context) => ContactForm()
};