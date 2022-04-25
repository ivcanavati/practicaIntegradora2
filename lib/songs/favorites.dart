import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/homePage/homePage.dart';

import '../homePage/bloc/home_bloc.dart';

class Favorites extends StatefulWidget {
  Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Color _iconColor = Colors.red;

  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection('users')
      .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots();
  int currentIndex = 0;
  Map<int, dynamic> songs = {};

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
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
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: users,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        final data = snapshot.requireData;
                        return ListView.builder(
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            songs[currentIndex] =
                                data.docs[index]['favorites']['song'];
                            return Stack(
                              //index: currentIndex,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              10,
                                          child: Card(
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: Image.network(
                                              '${data.docs[index]['favorites']['song']['portrait'].toString()}',
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    8,
                                                child: const DecoratedBox(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.indigo),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                      '${data.docs[index]['favorites']['song']['title'].toString()}',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      '${data.docs[index]['favorites']['song']['artist'].toString()}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite),
                                  color: _iconColor,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Eliminar favoritos",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text(
                                                    'El elemento sera eliminado a tus favoritos'),
                                                Text('¿Quiere continuar?')
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
                                              child: const Text('Continuar'),
                                              onPressed: () {
                                                _iconColor = Colors.white;
                                                /*BlocProvider.of<HomeBloc>(
                                                        context)
                                                    .add(DeleteFavEvent(
                                                        songs[widget.]));*/
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
