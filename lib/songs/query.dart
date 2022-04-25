import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/homePage/bloc/home_bloc.dart';
import 'package:practica2/homePage/homePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final Map<String, dynamic> data = {};

class songQuery extends StatefulWidget {
  final Map<String, dynamic> songInfo;
  songQuery({Key? key, required this.songInfo}) : super(key: key);

  @override
  State<songQuery> createState() => _songQueryState();
}

class _songQueryState extends State<songQuery> {
  Color _iconColor = Colors.white;
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
            actions: [
              IconButton(
                icon: Icon(Icons.favorite),
                color: _iconColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (_iconColor == Colors.red) {
                        return AlertDialog(
                          title: Text(
                            "Eliminar favoritos",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
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
                                BlocProvider.of<HomeBloc>(context)
                                    .add(DeleteEvent(widget.songInfo));
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      } else {
                        return AlertDialog(
                          title: Text(
                            "Agregar a favoritos",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text(
                                    'El elemento sera agregado a tus favoritos'),
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
                                BlocProvider.of<HomeBloc>(context)
                                    .add(QueryEvent(widget.songInfo));
                                Navigator.of(context).pop();
                                _iconColor = Colors.red;
                              },
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ],
            title: Text("Here you go",
                style: TextStyle(
                  fontSize: 25,
                )),
          ),
          body: Center(
              child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(widget.songInfo["result"]["spotify"]
                        ["album"]["images"][0]["url"]),
                    fit: BoxFit.fill,
                  ))),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(widget.songInfo["result"]["title"],
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              Container(
                child: Text(widget.songInfo["result"]["album"],
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                child: Text(widget.songInfo["result"]["artist"],
                    style: TextStyle(fontSize: 18)),
              ),
              Container(
                child: Text(widget.songInfo["result"]["release_date"],
                    style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                child: Text("Abrir con: "),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Icon(FontAwesomeIcons.spotify),
                      iconSize: 50,
                      tooltip: "Abrir en spotify",
                      onPressed: () {
                        _launchUrl(widget.songInfo["result"]["spotify"]
                            ["external_urls"]["spotify"]);
                      }),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.podcast),
                      iconSize: 50,
                      tooltip: "Abrir link multiplataforma",
                      onPressed: () {
                        _launchUrl(widget.songInfo["result"]["song_link"]);
                      }),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.apple),
                      iconSize: 50,
                      tooltip: "Abrir en apple music",
                      onPressed: () {
                        _launchUrl(
                            widget.songInfo["result"]["apple_music"]["url"]);
                      }),
                ],
              )
            ],
          )),
        );
      },
    );
  }
}

void _launchUrl(String _url) async {
  Uri _uri = Uri.parse(_url);
  if (!await launchUrl(_uri)) throw 'Could not launch $_url';
}
