import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:practica2/config/secrets.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final record = Record();

  HomeBloc() : super(HomeInitial()) {
    on<ListeningEvent>(_listen);
    on<RecordEvent>(_recordSong);
    on<SendDataEvent>(_sendSong);
    on<QueryEvent>(_query);
    on<DeleteEvent>(_delete);
    on<DeleteFavEvent>(_deleteFavs);
  }

  FutureOr<void> _listen(event, emit) async {
    emit(ListeningState());
  }

  FutureOr<void> _recordSong(event, emit) async {
    try {
      bool result = await record.hasPermission();
      if (!result) {
        emit(HomeErrorState());
        throw Error();
      }
      await record.start();
      await Future.delayed(Duration(seconds: 6));
      String? songPath = await record.stop();
      File recording = new File(songPath!);
      String recordingEncoded = base64Encode(recording.readAsBytesSync());
      emit(queryState(path: recordingEncoded));
    } catch (e) {
      emit(HomeErrorState());
      print(e);
      throw Error();
    }
  }

  FutureOr<void> _sendSong(event, emit) async {
    try {
      String recordingEncoded = state.props.first.toString();
      Uri uri = Uri.parse("https://api.audd.io/");
      Map<String, String> data = {
        'audio': recordingEncoded,
        'api_token': '$audToken',
        'return': 'apple_music,spotify,deezer',
      };
      final res = await http.post(uri, body: data);
      if (res.statusCode == 200) {
        var infoSong = jsonDecode(res.body);
        emit(HomeSuccessState(res: infoSong));
      }
    } catch (e) {
      emit(HomeErrorState());
      print(e);
      throw Error();
    }
  }
}

FutureOr<void> _query(event, emit) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Map<String, dynamic> songData = {
      'song': {
        'album': event.data["result"]["album"],
        'apple': event.data["result"]["apple_music"]["url"],
        'artist': event.data["result"]["artist"],
        'multi': event.data["result"]["song_link"],
        'portrait': event.data["result"]["spotify"]["album"]["images"][0]
            ["url"],
        'releaseDate': event.data["result"]["release_date"],
        'spotify': event.data["result"]["spotify"]["external_urls"]["spotify"],
        'title': event.data["result"]["title"],
      }
    };
    print('enviando');

    users.add({
      'user': FirebaseAuth.instance.currentUser?.email,
      'favorites': songData
    });

    emit(querySuccessState());
  } catch (e) {
    emit(HomeErrorState());
    print(e);
    throw Error();
  }
}

FutureOr<void> _delete(event, emit) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Map<String, dynamic> songData = {
      'song': {
        'album': event.data["result"]["album"],
        'apple': event.data["result"]["apple_music"]["url"],
        'artist': event.data["result"]["artist"],
        'multi': event.data["result"]["song_link"],
        'portrait': event.data["result"]["spotify"]["album"]["images"][0]
            ["url"],
        'releaseDate': event.data["result"]["release_date"],
        'spotify': event.data["result"]["spotify"]["external_urls"]["spotify"],
        'title': event.data["result"]["title"],
      }
    };

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('favorites', isEqualTo: songData)
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      ds.reference.delete();
    }

    emit(queryDeleteState());
  } catch (e) {
    emit(HomeErrorState());
    print(e);
    throw Error();
  }
}

FutureOr<void> _deleteFavs(event, emit) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('favorites', isEqualTo: event.data)
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      ds.reference.delete();
    }

    emit(queryDeleteState());
  } catch (e) {
    emit(HomeErrorState());
    print(e);
    throw Error();
  }
}
