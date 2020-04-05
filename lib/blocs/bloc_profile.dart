import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class BlocProfile extends BlocBase {
  String id;
  Firebase _firebase = Firebase();
  User _user;

  BehaviorSubject<User> _subject = BehaviorSubject<User>();
  Stream<User> get stream => _subject.stream;
  Sink<User> get sink => _subject.sink;

  void get signOut => _firebase.handleSignOut;

  BlocProfile({@required this.id}) {
    refreshUserFromDB();
  }

  void refreshUserFromDB() {
    _firebase.getUserData(id).listen((User user) {
      _user = user;
      sink.add(user);
    });
  }

  void takePicture(ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 500.0, maxHeight: 500.0)
        .asStream()
        .listen((file) {
      _firebase
          .savePicture(file, _firebase.storageUsers.child(id))
          .listen((str) {
        _user.imageUrl = str;
        Map m = _user.toMap();
        _firebase.addUser(_user.id, m);
        refreshUserFromDB();
      });
    });
  }

  void updateFirstname(String newFirstname) => _user.firstname = newFirstname;
  void updateLastname(String newLastname) => _user.lastname = newLastname;

  void saveChanges() {
    Map m = _user.toMap();
    if ((_user.firstname != null && _user.firstname != '') ||
        (_user.lastname != null && _user.lastname != '')) {
      _firebase.addUser(_user.id, m);
      refreshUserFromDB();
    }
  }

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Profile');
  }
}
