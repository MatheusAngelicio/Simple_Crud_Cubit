import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_firebase_crud_cubit/firebase_options.dart';
import 'package:simple_firebase_crud_cubit/src/app.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/auth_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/data_source/firebase_data_source.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'package:simple_firebase_crud_cubit/src/repository/auth_repository.dart';
import 'package:simple_firebase_crud_cubit/src/repository/implementation/auth_repository_impl.dart';
import 'package:simple_firebase_crud_cubit/src/repository/implementation/my_user_repository_impl.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await injectDependencies();

  runApp(
    BlocProvider(
      create: (_) => AuthCubit()..init(),
      child: const MyApp(),
    ),
  );
}

Future<void> injectDependencies() async {
  //Singleton =Significa que vai criar só 1vez durante todo ciclo de vida da aplicacao
  //Lazy = Significa que vai inicializar só quando formos utilizar
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<MyUserRepository>(() => MyUserRepositoryImpl());

  getIt.registerLazySingleton(() => FirebaseDataSource());
}
