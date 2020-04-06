import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';
import 'package:rxdart/rxdart.dart';

class BlocMessages extends BlocBase {
  String id;
  Firebase _firebase;

  BehaviorSubject<User> _subject = BehaviorSubject<User>();
  Stream<User> get stream => _subject.stream;
  Sink<User> get sink => _subject.sink;

  BlocMessages({@required this.id}) {
    _firebase = Firebase();
  }

  Query get query => _firebase.baseDiscussion.child(id);

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Messages');
  }
}
