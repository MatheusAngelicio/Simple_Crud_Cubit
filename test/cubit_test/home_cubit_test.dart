import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/home_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';

const _myUser1 = MyUser(id: '1', name: 'Yayo', lastName: 'Arellano', age: 28);
const _myUser2 = MyUser(id: '2', name: 'Jailson', lastName: 'Mendes', age: 68);

class MockMyUserRepo extends Mock implements MyUserRepository {}

void main() {
  late MockMyUserRepo mockRepo;
  setUp(() async {
    // vou resetar o getIt
    await getIt.reset();
    // vou inicializar o mockRepo
    mockRepo = MockMyUserRepo();
    // depois injetamos no repositorio este mock
    getIt.registerSingleton<MyUserRepository>(mockRepo);

    //IMPORTANTE
    //Lempre-se, vamos injetar isso no repositorio, porque esse é o unico
    // que esta usando no HomeCubit
  });

//vamos chegar se dois usuario foram emitidos corretamente
  blocTest<HomeCubit, HomeState>(
    'Two users will be emitted correnctly',
    build: () {
      when(() => mockRepo.getMyUsers()).thenAnswer((_) {
        return Stream.fromIterable([
          [_myUser1, _myUser2]
        ]);
      });
      return HomeCubit();
    },
    act: (cubit) => cubit.init(),
    // Ja que eu emiti na linha 34,35 -> uma lista com 2 usuarios, eu espero
    // um HomeState com loading false, e uma lista com os 2 usuarios que emiti
    expect: () => [
      const HomeState(
        isLoading: false,
        myUsers: [_myUser1, _myUser2],
      )
    ],
  );
}
