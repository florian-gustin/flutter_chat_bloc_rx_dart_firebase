import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/services/firebase.dart';
import 'package:rxdart/rxdart.dart';

class BlocRoot extends BlocBase {
  User _user = User();
  Firebase firebase = Firebase();

  BehaviorSubject<User> _subjectUser = BehaviorSubject<User>();
  Stream<User> get stream => _subjectUser.stream;
  Sink<User> get sink => _subjectUser.sink;

  BlocRoot() {
    sync();
  }

  Stream<FirebaseUser> get onAuthStateChanged => firebase.onAuthStateChanged;
  Stream<FirebaseUser> get signIn =>
      firebase.handleSignIn(_user.mail, _user.password);
  Stream<FirebaseUser> get signUp => firebase.handleCreate(
      _user.mail, _user.password, _user.firstname, _user.lastname);
  Stream<void> get signOut => firebase.handleSignOut;
  Stream<String> get getUID => firebase.userUID;

  void sync() async {
    sink.add(_user);
  }

  void updateIsLog() {
    _user.isLog = !_user.isLog;
    sync();
  }

  void addMail(String mail) {
    _user.mail = mail;
    sync();
  }

  void addPassword(String password) {
    _user.password = password;
    sync();
  }

  void addFirstname(String firstname) {
    _user.firstname = firstname;
    sync();
  }

  void addLastname(String lastname) {
    _user.lastname = lastname;
    sync();
  }

  void addUID(String id) {
    _user.id = id;
    _user.status = null;
    sync();
  }

  void handleLog() async {
    if (_user.mail == null) {
      _user.status = 'Mail is empty';
    } else if (_user.password == null) {
      _user.status = 'Password is empty';
    } else if (_user.isLog) {
      //se connecter
      try {
        this.signIn;
      } catch (e) {
        _user.status = e.toString();
      }
    } else if (_user.firstname == null) {
      _user.status = 'Firstname is empty';
    } else if (_user.lastname == null) {
      _user.status = 'Lastname is empty';
    } else {
      // creer user
      try {
        this.signUp;
      } catch (e) {
        _user.status = e.toString();
      }
    }
    sync();
  }

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Auth');
  }
}
