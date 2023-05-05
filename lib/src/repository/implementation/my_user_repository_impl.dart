import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'dart:io';

import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';

import '../../../main.dart';
import '../../data_source/firebase_data_source.dart';

class MyUserRepositoryImpl extends MyUserRepository {
  final FirebaseDataSource _fDataSource = getIt();

  @override
  Stream<Iterable<MyUser>> getMyUsers() {
    return _fDataSource.getMyUsers();
  }

  @override
  Future<void> saveMyUser(MyUser myUser, File? image) {
    return _fDataSource.saveMyUser(myUser, image);
  }

  @override
  Future<void> deleteMyUser(MyUser myUser) {
    return _fDataSource.deleteMyUser(myUser);
  }
}
