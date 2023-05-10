import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_firebase_crud_cubit/main.dart';
import 'package:simple_firebase_crud_cubit/src/app.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/auth_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/repository/auth_repository.dart';
import 'package:simple_firebase_crud_cubit/src/repository/my_user_repository.dart';
import 'package:simple_firebase_crud_cubit/src/ui/home_screen.dart';
import 'package:simple_firebase_crud_cubit/src/ui/intro_screen.dart';
import 'package:simple_firebase_crud_cubit/src/ui/splash_screen.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockMyUserRepo extends Mock implements MyUserRepository {}

// vai me retornar uma lista de usuarios
Stream<String> get loggedUserStream => Stream.fromIterable(['someUserId']);

void main() {
  late _MockAuthRepo mockRepo;
  late _MockMyUserRepo mockUserRepo;

// Vamos inicializar, primeiro reset no getIt
// depois inicializo os mocks
  setUp(() async {
    await getIt.reset();

    mockRepo = _MockAuthRepo();
    mockUserRepo = _MockMyUserRepo();

    // Depois, quando a funçao getMyUser é chamada no mockRepo
    // vou retornar uma lista de usuarios vazia
    // *NOTA = getMyUser retorna uma lista de usuarios e é uma stream

    when(() => mockUserRepo.getMyUsers())
        .thenAnswer((_) => Stream.fromIterable([]));

    // entao registro meu mock authrepo e userRepository
    getIt.registerSingleton<AuthRepository>(mockRepo);
    getIt.registerSingleton<MyUserRepository>(mockUserRepo);
  });

  // tambem foi precisar de uma funcao que me retorne meu app

  Widget getMyApp() {
    // injeto AuthCubit e mando chamar seu init
    return BlocProvider(
      create: (_) => AuthCubit()..init(),
      child: const MyApp(),
    );
  }

  testWidgets(
      'Intro screen will be shown after splash when the user is not logged in',
      (WidgetTester tester) async {
    final stream = Stream.fromIterable([null]);
    // quando mandar chamar a funçao onAuthStateChanged vai me retorna null
    // significa que nao foi iniciado a sessao
    when(() => mockRepo.onAuthStateChanged).thenAnswer((_) => stream);

    await tester.pumpWidget(getMyApp());
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);

//A função tester.pumpAndSettle() é usada para aguardar até que todas as tarefas
// assíncronas e animações sejam concluídas antes de prosseguir com a próxima
//verificação de teste. Isso garante que a interface do usuário esteja completamente
// carregada e que todas as transições e animações tenham sido concluídas antes de
//prosseguir com o próximo passo do teste.

//Aqui eu testo se > eu nao tiver sessao iniciado
// o app vai da SplashScreen para IntroScreen
    await tester.pumpAndSettle();
    expect(find.byType(IntroScreen), findsOneWidget);
  });

  testWidgets(
      'Home screen will be shown after splash shen the user is logged in',
      (WidgetTester tester) async {
    // agora quando chamo onAuthStateChanged eu passo um usuario logado
    when(() => mockRepo.onAuthStateChanged).thenAnswer((_) => loggedUserStream);

    // inicializamos
    await tester.pumpWidget(getMyApp());
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);

    //Agora espero que depois da splash, eu vá para homeScreen
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  // Test => quando estamos na homeScreen e clico pra fazer logout
  // o App deve voltar para tela de introScreen
  testWidgets('Pressing logout will return to the IntroScreen',
      (WidgetTester tester) async {
    when(() => mockRepo.onAuthStateChanged).thenAnswer((_) => loggedUserStream);
    when(() => mockRepo.signOut()).thenAnswer((_) async {});

    await tester.pumpWidget(getMyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // la no HomeScreen, no botao de logout tive que colocar
    // um key('Logout') tambem
    await tester.tap(find.byKey(const Key('Logout')));
    await tester.pumpAndSettle();

    expect(find.byType(IntroScreen), findsOneWidget);
  });
}
