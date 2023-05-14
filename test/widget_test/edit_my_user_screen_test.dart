import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';
import 'package:simple_firebase_crud_cubit/src/ui/edit_my_user_screen.dart';

const _myUser1 = MyUser(id: '111', name: 'Yayo', lastName: 'Arellano', age: 28);

class _MockMyUser extends Mock implements MyUser {}

class _MockMyUserRepo extends Mock implements MyUserRepository {}

void main() {
  late _MockMyUserRepo mockRepo;

  setUp(() async {
    await getIt.reset();
    registerFallbackValue(_MockMyUser());
    mockRepo = _MockMyUserRepo();
    getIt.registerSingleton<MyUserRepository>(mockRepo);
  });

  Widget getMaterialApp({MyUser? user}) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Sempre que for chamar EditMyUserScreen, posso passar um
        // parametro ou nao.
        return MaterialPageRoute(
            settings: RouteSettings(arguments: user),
            builder: (_) => const EditMyUserScreen());
      },
    );
  }

// test criar um usuario
  testWidgets('Saving user will call repository successfully',
      (WidgetTester tester) async {
    // quando chamo a funcao saveMyUser nao vamos fazer nada
    when(() => mockRepo.saveMyUser(any(), null)).thenAnswer((_) async {});
    //quando chamo a funcao newid retornamos o id 5555
    when(() => mockRepo.newId()).thenReturn('5555');

    //chamo a funcao que me retorna EditMyUserScreen
    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    // vou buscar um widget que tenha a key = Name
    // e vou por o texto Yayo
    await tester.enterText(find.byKey(const Key('Name')), 'Yayo');
    // depois vou buscar o widget que tenha a key = Last Name
    // ....
    await tester.enterText(find.byKey(const Key('Last Name')), 'Are');
    await tester.enterText(find.byKey(const Key('Age')), '25');

    await tester.pumpAndSettle();

    // buscamos um botao com text Save, e pressionamos
    await tester.tap(find.text('Save'));
    // depois esperamos 3segundos
    await tester.pump(const Duration(seconds: 3));

    // e vamos verificar se o repositorio encontra um usuario que tenha
    // as propriedades de newUser
    const newUser = MyUser(id: '5555', name: 'Yayo', lastName: 'Are', age: 25);
    verify(() => mockRepo.saveMyUser(newUser, null)).called(1);
  });

  // test para atualizar um uzuario
  testWidgets('Updating user will call repository',
      (WidgetTester tester) async {
    when(() => mockRepo.saveMyUser(any(), null)).thenAnswer((_) async {});

    await tester.pumpWidget(getMaterialApp(user: _myUser1));
    await tester.pumpAndSettle();
    // agora colocando os valores novos da ediçao

    await tester.enterText(find.byKey(const Key('Name')), 'Hola');
    await tester.enterText(find.byKey(const Key('Last Name')), 'Mundo');
    await tester.enterText(find.byKey(const Key('Age')), '10');

    // buscamos um botao com text Save, e pressionamos
    await tester.tap(find.text('Save'));
    // depois esperamos 3segundos
    await tester.pump(const Duration(seconds: 3));

    final updateUser =
        _myUser1.copyWith(name: 'Hola', lastName: 'Mundo', age: 10);
    verify(() => mockRepo.saveMyUser(updateUser, null)).called(1);
  });

  // test para verificar se esta mostrando ou nao o botao
  // de delete user (só deve mostrar se estiver editando usuario)
  testWidgets('When is a new user delete button is not visible',
      (WidgetTester tester) async {
    // note que nao estou passando nenhum parametro para getMaterialApp
    // entao, é um usuario novo
    await tester.pumpWidget(getMaterialApp());

    // (tester.pumpAndSettle();)
    //Essa linha espera até que todas as animações e transições na tela sejam
    //concluídas. Em outras palavras, ela garante que a interface do usuário
    //tenha tempo suficiente para ser totalmente renderizada e pronta para o
    // próximo teste. Isso é útil para garantir que a interface do usuário seja
    //estável antes de executar o teste.
    await tester.pumpAndSettle();

    // aqui eu verifico se um widget com a Key 'Delete' está sendo exibida na tela
    // findsNothing significa :
    //O findsNothing é um matcher (verificador) de teste na biblioteca de
    //teste flutter_test. Nesse caso específico, ele é usado para verificar se
    // nenhum widget correspondente é encontrado ao buscar pelo widget com a
    //chave Key('Delete').

    // Resumindo, eu espero nao ver um widget com a Key 'Delete'
    expect(find.byKey(const Key('Delete')), findsNothing);
  });

  // test para verificar se o botao Delete aparece quando vou
  // editar um usuario
  testWidgets('When is an editing user delete button is visible',
      (WidgetTester tester) async {
    await tester.pumpWidget(getMaterialApp(user: _myUser1));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('Delete')), findsOneWidget);
  });

  //test quando clicar em Delete, vai chamar a funcao que deleta
  // do repositorio corretamente
  testWidgets('Deleting an editing user will call repository successfully',
      (WidgetTester tester) async {
    // quando chamar deleteMyUser nao vou retornar nada
    when(() => mockRepo.deleteMyUser(any())).thenAnswer((_) async {});

    await tester.pumpWidget(getMaterialApp(user: _myUser1));
    await tester.pumpAndSettle();

    // vou buscar o widget que tenha chave Delete e vou clicar nele
    await tester.tap(find.byKey(const Key('Delete')));
    await tester.pump();

    // depois vou verificar que o repositorio chamou 1x com _myUser1
    verify(() => mockRepo.deleteMyUser(_myUser1)).called(1);
  });
}
