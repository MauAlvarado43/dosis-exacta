import 'package:dosis_exacta/model/contact.dart';

class ContactVM {

  Future<List<Contact>?> getContacts() async {
    return await Contact.getAll();
  }

  Future<bool> createContact({ required String name, required String email, required String phone }) async {

    Contact contact = Contact(name: name, email: email, phone: phone);

    try {
      await contact.save();
      return true;
    }
    catch(e){
      return false;
    }

  }

  Future<bool> updateContact(Contact contact, { name, email, phone }) async {

    if(name != null) contact.name = name;
    if(email != null) contact.email = email;
    if(phone != null) contact.phone = phone;

    try {
      await contact.update();
      return true;
    }
    catch(e){
      return false;
    }

  }

  Future<bool> deleteContact(Contact contact) async {

    try {
      await contact.delete();
      return true;
    }
    catch(e){
      return false;
    }

  }

}