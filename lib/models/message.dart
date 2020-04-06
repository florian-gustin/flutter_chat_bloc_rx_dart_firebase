import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Message {
  String from;
  String to;
  String text;
  String imageUrl;
  String dateString;

  Message({@required DataSnapshot snapshot}) {
    Map v = snapshot.value;
    from = v['from'];
    to = v['to'];
    text = v['text'];
    imageUrl = v['imageUrl'];
    dateString = v['dateString'];
  }
}
