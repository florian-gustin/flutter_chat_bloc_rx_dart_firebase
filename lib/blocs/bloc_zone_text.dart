import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';
import 'package:rxdart/rxdart.dart';

class BlocZoneText extends BlocBase {
  String id;
  User interlocutor;
  Firebase _firebase;
  TextEditingController textEditingController = TextEditingController();

  BehaviorSubject<User> _subject = BehaviorSubject<User>();
  Stream<User> get stream => _subject.stream;
  Sink<User> get sink => _subject.sink;

  BlocZoneText({@required this.id, @required this.interlocutor}) {
    _firebase = Firebase();
    getInterlocutorFromDB(interlocutor);
  }

  getInterlocutorFromDB(User user) {
    _firebase.getUserData(user.id).listen((User user) {
      sink.add(user);
    });
  }

  sendButtonPressed() {
    if (textEditingController.text != null &&
        textEditingController.text != '') {
      String text = textEditingController.text;
    } else {
      print('text empty');
    }
  }

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Zone Text');
  }
}
