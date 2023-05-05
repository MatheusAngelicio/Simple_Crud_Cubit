import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final MyUserRepository _userRepository = getIt();
  StreamSubscription? _myUsersSubscription;

  HomeCubit() : super(const HomeState());

  Future<void> init() async {
    // aqui vou subscrever a lista de usuarios toda vez que houver uma mudança
    //vou emit um estado e chamar essa funcao "myUserlisten"
    _myUsersSubscription = _userRepository.getMyUsers().listen(myUserListen);
  }

  // quando recebemos uma lista de usuarios vamos emitir um estado novo
  void myUserListen(Iterable<MyUser> myUsers) async {
    emit(HomeState(isLoading: false));
  }
}

class HomeState extends Equatable {
  final bool isLoading;
  final Iterable<MyUser> myUsers;

// Por padrao loading é true
// por padrao myUsers é uma lista vazia
  const HomeState({
    this.isLoading = true,
    this.myUsers = const [],
  });

// Como extendo de Equatable, utilizo props e coloco duas variaveis
  @override
  List<Object?> get props => [isLoading, myUsers];
}
