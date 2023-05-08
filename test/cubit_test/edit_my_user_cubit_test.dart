import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/edit_my_user_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';

const _myUser2 = MyUser(id: '2', name: 'Jailson', lastName: 'Mendes', age: 68);

class MockMyUserRepo extends Mock implements MyUserRepository {}

class MockMyUser extends Mock implements MyUser {}

void main() {
  late MockMyUserRepo mockRepo;
  setUp(() async {
    await getIt.reset();
    // em algumas funcoes do MyUserRepository preciso de um usuario,
    // com registerFallbackValue nao passo nenhum usuario,
    // automaticamente mock vai passar o MockMyUser
    registerFallbackValue(MockMyUser());
    mockRepo = MockMyUserRepo();
    getIt.registerSingleton<MyUserRepository>(mockRepo);
  });

  blocTest<EditMyUserCubit, EditMyUserState>(
    'Saving a new user will succeed',
    build: () {
      // quando salvo meu usuario, passo any() (significa qualquer coisa)
      // passo imagem null, e nao faco nada com a resposta
      // por que nao é mada ? por que quando guardamos um usuario, a resposta é void

      when(() => mockRepo.saveMyUser(any(), null)).thenAnswer((_) async {});
      when(() => mockRepo.newId()).thenAnswer((_) => '5555');
      // se aqui é null significa que nao estou editando um usuario,
      // ES um usuario nuevo.
      return EditMyUserCubit(null);
    },
    act: (cubit) {
      // Açao de salvar usuario
      return cubit.saveMyUser('Geraldo', 'Doe', 25);
    },
    expect: () => [
      // eu espero que o primeiro stado que se emita seja
      // isloading true, isdone false
      const EditMyUserState(
        isLoading: true,
        isDone: false,
      ),
      // o proximo estado eu espero
      // isLoading true, isDone true
      const EditMyUserState(isLoading: true, isDone: true)
    ],
    verify: (cubit) {
      // verificar se meu usuario foi salvo corretamente
      // verificar se meu repositorio mandou esse usuario
      const newUser =
          MyUser(id: '5555', name: 'Geraldo', lastName: 'Doe', age: 25);
      //vou verificar se repositorio salvou esse usuario, e chamou apenas 1x
      verify(() => mockRepo.saveMyUser(newUser, null)).called(1);
    },
  );

  blocTest<EditMyUserCubit, EditMyUserState>('Updating a user will succed',
      build: () {
        when(() => mockRepo.saveMyUser(any(), null)).thenAnswer((_) async {});
        return EditMyUserCubit(_myUser2);
      },
      act: (cubit) {
        // Novos parametros do usuario atualizado
        return cubit.saveMyUser('Hola', 'Mundo', 10);
      },
      expect: () => [
            const EditMyUserState(
              isLoading: true,
              isDone: false,
            ),
            const EditMyUserState(isLoading: true, isDone: true)
          ],
      verify: (cubit) {
        final updateUser =
            _myUser2.copyWith(name: 'Hola', lastName: 'Mundo', age: 10);
        verify(() => mockRepo.saveMyUser(updateUser, null)).called(1);
      });

  //Test no delete de um usuario novo
  blocTest<EditMyUserCubit, EditMyUserState>(
      'Trying to delete a new user will not call the repository',
      build: () {
        // null entao estou fazendo um usuario novo
        return EditMyUserCubit(null);
      },
      act: (cubit) {
        return cubit.deleteMyUser();
      },
      // espero dois estados
      expect: () => [
            const EditMyUserState(
              isLoading: true,
              isDone: false,
            ),
            const EditMyUserState(
              isLoading: true,
              isDone: true,
            )
          ],
      verify: (cubit) {
        // verifica se mockRepo.deleteMyUser nunca é chamado
        verifyNever(() => mockRepo.deleteMyUser(any()));
      });

  //Test no delete de um usuario que existe no banco de dados
  blocTest<EditMyUserCubit, EditMyUserState>(
      'Trying to delete an existing user will call the repository',
      build: () {
        when(() => mockRepo.deleteMyUser(any())).thenAnswer((_) async {});
        return EditMyUserCubit(_myUser2);
      },
      act: (cubit) {
        return cubit.deleteMyUser();
      },
      expect: () => [
            const EditMyUserState(isLoading: true, isDone: false),
            const EditMyUserState(isLoading: true, isDone: true)
          ],
      verify: (cubit) {
        verify(() => mockRepo.deleteMyUser(_myUser2)).called(1);
      });
}
