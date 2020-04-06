import 'package:flutter/foundation.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';
import 'package:rxdart/rxdart.dart';

class BlocChat extends BlocBase {
  String id;
  User interlocutor;
  Firebase _firebase;

  BehaviorSubject<User> _subject = BehaviorSubject<User>();
  Stream<User> get stream => _subject.stream;
  Sink<User> get sink => _subject.sink;

  BlocChat({@required this.id, this.interlocutor}) {
    _firebase = Firebase();
    getInterlocutorFromDB(interlocutor);
  }

  getInterlocutorFromDB(User user) {
    _firebase.getUserData(user.id).listen((User user) {
      sink.add(user);
    });
  }

  @override
  void dispose() {
    fDisposingBlocOf('BlocChat');
  }
}
