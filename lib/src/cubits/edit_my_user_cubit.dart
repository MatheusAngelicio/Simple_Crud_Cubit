import 'dart:ffi';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';

import '../model/my_user.dart';

class EditMyUserCubit extends Cubit<EditMyUserState> {
  final MyUserRepository _userRepository = getIt();

  // se eu estiver criando um usuario novo, o valor de _toEdit será nullo,
  // se euu for editar, eu terei o usuario que irei editar
  MyUser? _toEdit;

  EditMyUserCubit(this._toEdit) : super(const EditMyUserState());

  void setImage(File? imageFile) async {
    emit(state.copyWith(pickedImage: imageFile));
  }

  // Eu emito isLoading true antes de fazer a request,
  // depois eu nao emito isLoading false, porque eu vou voltar uma tela
  // entao fica assim, eu mostro o loading enquanto salvo os dados
  // depois emito isDone pra voltar uma tela
  // com isso nao preciso emitir isLoading false
  Future<void> saveMyUser(
    String name,
    String lastName,
    int age,
  ) async {
    emit(state.copyWith(isLoading: true));

    // se eu estou editando o usuario, eu uso o msm
    // se for um usuario novo, devo criar um id
    final uid = _toEdit?.id ?? _userRepository.newId();
    _toEdit = MyUser(
        id: uid,
        name: name,
        lastName: lastName,
        age: age,
        image: _toEdit?.image);

    await _userRepository.saveMyUser(_toEdit!, state.pickedimage);
    emit(state.copyWith(isDone: true));
  }

  Future<void> deleteMyUser() async {
    emit(state.copyWith(isLoading: true));
    if (_toEdit != null) {
      await _userRepository.deleteMyUser(_toEdit!);
    }

    emit(state.copyWith(isDone: true));
  }
}

class EditMyUserState extends Equatable {
  final File? pickedimage;
  final bool isLoading;

  final bool isDone;

  const EditMyUserState(
      {this.pickedimage, this.isLoading = false, this.isDone = false});

  @override
  List<Object?> get props => [pickedimage?.path, isLoading, isDone];

  EditMyUserState copyWith({
    File? pickedImage,
    bool? isLoading,
    bool? isDone,
  }) {
    return EditMyUserState(
      pickedimage: pickedimage ?? this.pickedimage,
      isLoading: isLoading ?? this.isLoading,
      isDone: isDone ?? this.isDone,
    );
  }
}
