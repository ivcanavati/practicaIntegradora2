import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
        print(infoSong.toString());
        emit(HomeSuccessState(res: infoSong));
      }
    } catch (e) {
      emit(HomeErrorState());
      print(e);
      throw Error();
    }
  }
}
