import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_firebase_crud_cubit/src/cubits/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home Screen...",
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
                child: Text('Sign Out'))
          ],
        ),
      ),
    );
  }
}
