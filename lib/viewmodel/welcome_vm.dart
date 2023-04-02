import 'package:dosis_exacta/model/user.dart';

class WelcomeVW {

  bool registerUser(String name) {

    if(name.isNotEmpty) {
      User user = User(name: name);
      user.save();
      return true;
    }

    return false;

  }

  Future<User?> checkExistingUser() async {
    List<User>? users = await User.getAll();
    if(users != null && users.isNotEmpty) return users.first;
    return null;
  }

}