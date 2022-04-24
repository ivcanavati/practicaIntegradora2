import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background.gif",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar: AppBar(
              title: Text(
            'Sign In',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fill,
                    ))),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Container(
                  child: MaterialButton(
                      hoverColor: Color.fromARGB(255, 17, 61, 18),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.g_mobiledata_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Iniciar con Google",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      color: Colors.green,
                      minWidth: MediaQuery.of(context).size.width - 30,
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(GoogleAuthEvent());
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
