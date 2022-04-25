import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/homePage/bloc/home_bloc.dart';
import 'package:practica2/songs/query.dart';

class awatingApi extends StatefulWidget {
  awatingApi({Key? key}) : super(key: key);

  @override
  State<awatingApi> createState() => _awatingApiState();
}

class _awatingApiState extends State<awatingApi> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeSuccessState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => songQuery(songInfo: state.res)));
        }
      },
      builder: (context, state) {
        if (state is! HomeSuccessState) {
          BlocProvider.of<HomeBloc>(context).add(SendDataEvent());
        }
        return Scaffold(
          body: Center(
            child: Text("Esperando respuesta..."),
          ),
        );
      },
    );
  }
}
