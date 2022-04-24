import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/auth/bloc/auth_bloc.dart';
import 'package:practica2/auth/loginScreen.dart';
import 'package:practica2/homePage/bloc/home_bloc.dart';
import 'package:practica2/homePage/homePage.dart';
import 'package:practica2/songs/bloc/song_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc()..add(VerifyAuthEvent()),
      ),
      BlocProvider(
        create: (context) => HomeBloc(),
      ),
      BlocProvider(
        create: (context) => SongBloc(),
      ),
    ],
    child: FindTrackApp(),
  ));
}

class FindTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FindTrackApp',
        theme: ThemeData(primaryColor: Colors.purple),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        home: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Usuario no identificado"),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthSuccessState) {
              return homePage();
            } else if (state is UnAuthState ||
                state is AuthErrorState ||
                state is SignOutSuccessState) {
              return LoginScreen();
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
