import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/auth_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/repository/auth_repository.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepo mockRepo;
  setUp(() async {
    await getIt.reset();
    mockRepo = MockAuthRepo();
    getIt.registerSingleton<AuthRepository>(mockRepo);
  });

  // No blocTest devo passar qual o cubit, e qual os estados do cubit
  blocTest<AuthCubit, AuthState>(
    // mensagem de sucesso
    'Signed out state will be emitted',
    // simulando a emissao de do valor signedOut nno cubit (na logica está :
    // quando eu enviar null pela Stream, devo emit signedOut)
    build: () {
      when(() => mockRepo.onAuthStateChanged)
          // aqui estou enviando null pela stream
          .thenAnswer((_) => Stream.fromIterable([null]));
      return AuthCubit();
    },
    // padrao
    act: (cubit) async => await cubit.init(),
    // qual estado eu espero do cubit quando eu mando null na Stream
    expect: () => [
      AuthState.signedOut,
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'Signed in state will be emitted',
    build: () {
      when(() => mockRepo.onAuthStateChanged)
          .thenAnswer((_) => Stream.fromIterable(['someUserId']));
      return AuthCubit();
    },
    act: (cubit) => cubit.init(),
    expect: () => [AuthState.signedIn],
  );

  blocTest<AuthCubit, AuthState>(
      'Signed out state will be emitted after calling signOut',
      build: () {
        when(() => mockRepo.onAuthStateChanged)
            .thenAnswer((_) => Stream.fromIterable(['someUserId']));
        // Quando pressionar o botao signout, nao vamos fazer nada
        when(() => mockRepo.signOut()).thenAnswer((_) async {});
        return AuthCubit();
      },
      act: (cubit) async {
        await cubit.init();
        await cubit.signOut();
      },
      // esperado, primeiro resultado signin, segundo resultado signout
      expect: () => [AuthState.signedIn, AuthState.signedOut],
      verify: (cubit) {
        // verificar se a funcao signOut é chamada apenas 1x
        verify(() => mockRepo.signOut()).called(1);
      });
}
