import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';
import 'package:simple_firebase_crud_cubit/src/ui/home_screen.dart';

const _myUser1 = MyUser(id: '111', name: 'Yayo', lastName: 'Arellano', age: 28);
const _myUser2 = MyUser(id: '222', name: 'Gera', lastName: 'Doe', age: 25);

class _MockMyUserRepo extends Mock implements MyUserRepository {}

void main() {
  late _MockMyUserRepo mockRepo;

  setUp(() async {
    await getIt.reset();
    mockRepo = _MockMyUserRepo();
    // agora vou injetar usando getIt
    getIt.registerSingleton<MyUserRepository>(mockRepo);
  });

  // uma funcao que me retorne um widget HomeScreen
  Widget getMaterialApp() {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }

  // test para verificar se o repositorio me retorna vazio
  // quando nao tenho usuarios
  testWidgets('Empty list when repository returns 0 users',
      (WidgetTester tester) async {
    // enquanto quando chamar a funçao getMyUsers
    when(() => mockRepo.getMyUsers()).thenAnswer((_) {
      // vamos retornar uma lista vazia
      return Stream.fromIterable([]);
    });

    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    // nao devo encontar nenhum usuario
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('Two items in the list when repository returns 2 users',
      (WidgetTester tester) async {
    when(() => mockRepo.getMyUsers()).thenAnswer((_) {
      return Stream.fromIterable([
        [_myUser1, _myUser2]
      ]);
    });

    await tester.pumpWidget(getMaterialApp());
    await tester.pumpAndSettle();

    // devo encontrar 2 usuarios
    // por que buscar widgget do tipo card?
    // no homeScreen temos dentro de listView.builder
    // um return Card (Cada usuario retorna um widget do tipo card)
    expect(find.byType(Card), findsNWidgets(2));
  });
}
