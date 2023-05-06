import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';

class FirebaseDataSource {
  User get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated exception');
    return user;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  String newId() {
    return firestore.collection('tmp').doc().id;
  }

  Stream<Iterable<MyUser>> getMyUsers() {
    return firestore
        .collection('user/${currentUser.uid}/myUsers')
        .snapshots()
        .map((it) => it.docs.map((e) => MyUser.fromFirebaseMap(e.data())));
  }

  Future<void> saveMyUser(MyUser myUser, File? image) async {
    final ref = firestore.doc('user/${currentUser.uid}/myUsers/${myUser.id}');

    // PRIMEIRO SALVO A IMAGEM NO STORAGE
    // DEPOIS SALVO MEU USUARIO NO FIRESTORE

    // se a imagem nao é nula, entao temos que subila no storage
    if (image != null) {
      // se o usuario ja tem uma imagem, entao devemos excluir a imagem atual
      // antes de subir a imagem nova
      if (myUser.image != null) {
        await storage.refFromURL(myUser.image!).delete();
      }

      // nome do arquivo
      final fileNmae = image.uri.pathSegments.last;
      // rota aonde vou guardar a imagem
      final imagePath = '${currentUser.uid}/myUsersImage/$fileNmae';
      // referencia
      final storageRef = storage.ref(imagePath);
      //agora posso salvara imagem
      await storageRef.putFile(image);

      // entao vou guardar a imagem no meu objeto myUser.
      final url = await storageRef.getDownloadURL();
      myUser = myUser.copyWith(image: url);
    }
    // Agora sim salvo meu usuario no firestore
    await ref.set(myUser.toFirebaseMap(), SetOptions(merge: true));
  }

  Future<void> deleteMyUser(MyUser myUser) async {
    final ref = firestore.doc('user/${currentUser.uid}/myUsers/${myUser.id}');

    // se o usuario tem uma imagem, eu exclui-a
    if (myUser.image != null) {
      await storage.refFromURL(myUser.image!).delete();
    }
    // entao, excluo o usuario
    await ref.delete();
  }
}
