import 'package:dosis_exacta/model/user.dart';

class WelcomeVW {

  Future<bool> registerUser(String name) async {

    if(name.isNotEmpty) {

      User user = User(name: name);

      try {
        await user.save();
        return true;
      }
      catch (e){
        return false;
      }

    }

    return false;

  }

  Future<User?> checkExistingUser() async {
    List<User>? users = await User.getAll();
    if(users != null && users.isNotEmpty) return users.first;
    return null;
  }

}