import 'dart:async';
import 'package:flutter/services.dart';

abstract class Bloc {
  void dispose();
}

class DeepLinkBloc extends Bloc {

  //Event Channel creation
  static const stream = const EventChannel('app.elesson.com.br/events');

  //Method channel creation
  static const platform = const MethodChannel('app.elesson.com.br/channel');

  StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;


  DeepLinkBloc() {
    //verificando se foi iniciado pelo deep link
    startUri().then(_onRedirected);
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }


  _onRedirected(String uri) {
    stateSink.add(uri);
  }


  @override
  void dispose() {
    _stateController.close();
  }


  Future<String> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}