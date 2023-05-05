import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'dart:io';

abstract class MyUserRepository {
  Stream<Iterable<MyUser>> getMyUsers();

  Future<void> saveMyUser(MyUser myUser, File? image);

  Future<void> deleteMyUser(MyUser myUser);
}
