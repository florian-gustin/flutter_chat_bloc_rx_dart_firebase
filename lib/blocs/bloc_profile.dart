import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';
import 'package:image_picker/image_picker.dart';

class BlocProfile extends BlocBase {
  String id;
  Firebase _firebase = Firebase();
  User _user;

  Stream<User> get userData => _firebase.getUserData(id);

  void syncToModel(User user) {
    _user = user;
  }

  void takePicture(ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 500.0, maxHeight: 500.0)
        .asStream()
        .listen((file) {
      _firebase
          .savePicture(file, _firebase.storageUsers.child(id))
          .listen((str) {
        Map m = _user.toMap();
        m['imageUrl'] = str;
        _firebase.addUser(_user.id, m);
      });
    });

    // problem le bloc User écoute pas si je le reactualise pas.
  }

  BlocProfile({@required this.id});

  void fromStreamToUser(snapshot) {
    _user = User.fromMap(snapshot);
  }

  void updateFirstname(String newFirstname) {
    _user.firstname = newFirstname;
  }

  void updateLastname(String newLastname) {
    _user.lastname = newLastname;
  }

  void saveChanges() {}

  void signOut() {
    _firebase.handleSignOut;
  }

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Profile');
  }
}
