import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/homePage/homePage.dart';
import 'package:practica2/songs/bloc/song_bloc.dart';

class songQuery extends StatefulWidget {
  final Map<String, dynamic> songInfo;
  songQuery({Key? key, required this.songInfo}) : super(key: key);

  @override
  State<songQuery> createState() => _songQueryState();
}

class _songQueryState extends State<songQuery> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        if (state is SongInitial) {}
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => homePage()));
              },
            ),
            title: Text("Here you go",
                style: TextStyle(
                  fontSize: 25,
                )),
          ),
          body: Container(child: Text(widget.songInfo.toString())),
        );
      },
    );
  }
}
