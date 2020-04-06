import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';

class Discussion {
  String id;
  String lastMsg;
  User user;

  Discussion({@required DataSnapshot snapshot}) {
    this.id = snapshot.value['myID'];
    this.lastMsg = snapshot.value['lastMsg'];
    user = User.fromMap(snapshot);
  }
}
