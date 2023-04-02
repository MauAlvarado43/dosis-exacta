import 'package:dosis_exacta/model/user.dart';

class HomeVM {

  Future<User?> checkExistingUser() async {
    List<User>? users = await User.getAll();
    if(users != null && users.isNotEmpty) return users.first;
    return null;
  }

}