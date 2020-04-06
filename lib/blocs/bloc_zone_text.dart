import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class BlocZoneText extends BlocBase {
  String id;
  User me;
  User interlocutor;
  Firebase _firebase;
  TextEditingController textEditingController = TextEditingController();

  BehaviorSubject<List<User>> _subject = BehaviorSubject<List<User>>();
  Stream<List<User>> get stream => _subject.stream;
  Sink<List<User>> get sink => _subject.sink;

  BlocZoneText({@required this.id, @required this.interlocutor}) {
    _firebase = Firebase();
    getInterlocutorFromDB(interlocutor);
  }

  void getInterlocutorFromDB(User user) {
    ZipStream([
      _firebase.getUserData(id),
      Stream<User>.value(interlocutor),
    ], (streams) => streams).listen((users) {
      me = users[0];
      sink.add(users);
    });
  }

  void sendButtonPressed(BuildContext context) {
    if (textEditingController.text != null &&
        textEditingController.text != '') {
      String text = textEditingController.text;
      _firebase.sendMessage(interlocutor, me, text, null);
      textEditingController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      print('text empty');
    }
  }

  void takePicture(ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 1000.0, maxHeight: 1000.0)
        .asStream()
        .listen((file) {
      String date = DateTime.now().millisecondsSinceEpoch.toString();
      _firebase
          .savePicture(file, _firebase.storageMsgs.child(id).child(date))
          .listen((str) {
        _firebase.sendMessage(interlocutor, me, null, str);
      });
    });
  }

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Zone Text');
  }
}
