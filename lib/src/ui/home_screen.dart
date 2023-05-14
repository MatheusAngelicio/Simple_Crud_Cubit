import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/auth_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/home_cubit.dart';
import 'package:simple_firebase_crud_cubit/src/ui/widgets/custom_image.dart';

import '../navigation/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            key: const Key('Logout'),
            onPressed: () {
              final authCubit = context.read<AuthCubit>();
              authCubit.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Routes.editUser);
        },
      ),
      body: BlocProvider(
        create: (context) => HomeCubit()..init(),
        child: BlocBuilder<HomeCubit, HomeState>(
          // Aqui vamos observar o stado atual
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.myUsers.length,
              itemBuilder: (context, index) {
                //vamos obter o usuario que se encontra na posicao index
                final myUser = state.myUsers.elementAt(index);
                // depois criamos um card para cada usuario
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.editUser,
                          arguments: myUser);
                    },
                    leading: ClipOval(
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: CustomImage(
                          imageUrl: myUser.image,
                        ),
                      ),
                    ),
                    title: Text('${myUser.name} ${myUser.lastName}'),
                    subtitle: Text('Age: ${myUser.age}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
