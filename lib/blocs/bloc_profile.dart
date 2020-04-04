import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';

class BlocProfile extends BlocBase {
  String id;
  Firebase _firebase = Firebase();
  User _user;

  String get firstname => _user.firstname;
  String get lastname => _user.lastname;

  Stream<DataSnapshot> get userData => _firebase.getUserData(id);

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
