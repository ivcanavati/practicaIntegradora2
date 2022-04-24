import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/auth/bloc/auth_bloc.dart';
import 'package:practica2/homePage/searching.dart';
import 'package:practica2/songs/favorites.dart';
import 'bloc/home_bloc.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is queryState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => awatingApi()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            child: Center(
              child: Column(children: [
                SizedBox(
                  height: 50,
                ),
                if (state is! ListeningState) ...[
                  Container(
                      child: Text(
                    "Toque para escuchar",
                    style: TextStyle(fontSize: 25),
                  )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                        child: Image.asset('assets/logo.png', fit: BoxFit.fill),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(ListeningEvent());
                          BlocProvider.of<HomeBloc>(context).add(RecordEvent());
                        }),
                  ),
                ] else ...[
                  Container(
                      child: Text("Escuchando...",
                          style: TextStyle(fontSize: 25))),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                  AvatarGlow(
                    glowColor: Colors.indigo,
                    endRadius: 150,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                          child:
                              Image.asset('assets/logo.png', fit: BoxFit.fill),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: Colors.white,
                          ),
                          onPressed: () {}),
                    ),
                  ),
                ],
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Tooltip(
                      message: "Ver favoritos",
                      child: ElevatedButton(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Favorites()));
                          }),
                    ),
                    Tooltip(
                      message: "Cerrar sesion",
                      child: ElevatedButton(
                          child: Icon(
                            Icons.power_settings_new_outlined,
                            color: Colors.black,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            showAlertDialog(context);
                          }),
                    )
                  ],
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Cerrar session",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    content: SingleChildScrollView(
      child: ListBody(
        children: const <Widget>[
          Text(
              'Al cerrar la sesion de su cuenta sera redirigido a la pantalla de Log In, ¿Quiere continuar?'),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: const Text('Cancelar'),
        onPressed: () {
          Navigator.of(context).pop();
          ;
        },
      ),
      TextButton(
        child: const Text('Cerrar Sesion'),
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
        },
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
