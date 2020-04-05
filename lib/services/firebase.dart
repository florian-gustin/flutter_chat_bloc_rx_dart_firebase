import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';

class Firebase {
  // auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  Firebase();

  Stream<FirebaseUser> get onAuthStateChanged {
    return auth.onAuthStateChanged.map((FirebaseUser user) => user);
  }

  Stream<void> get handleSignOut => auth.signOut().asStream();

  Stream<FirebaseUser> handleSignIn(String mail, String password) => auth
      .signInWithEmailAndPassword(email: mail, password: password)
      .catchError(print)
      .asStream()
      .map((AuthResult authResult) => authResult?.user);

  Stream<FirebaseUser> handleCreate(
      String mail, String password, String firstname, String lastname) {
    auth
        .createUserWithEmailAndPassword(email: mail, password: password)
        .catchError(print)
        .asStream()
        .map((AuthResult authResult) {
      String uid = authResult?.user?.uid;
      if (uid != null) {
        Map<String, String> map = {
          'uid': uid,
          'firstname': firstname,
          'lastname': lastname
        };
        addUser(uid, map);
      }
      return authResult?.user;
    });
  }

  Stream<String> get userUID =>
      auth.currentUser().asStream().map((FirebaseUser user) => user?.uid);

  // db
  static final base = FirebaseDatabase.instance.reference();
  final baseUser = base.child('users');

  void addUser(String uid, Map map) {
    try {
      baseUser.child(uid).set(map).asStream();
    } catch (e) {
      print(e);
    }
  }

  Stream<User> getUserData(String id) {
    return baseUser
        .child(id)
        .once()
        .catchError(print)
        .asStream()
        .map((DataSnapshot dataSnapshot) => User.fromMap(dataSnapshot));
  }

  // storage
  static final baseStorage = FirebaseStorage.instance.ref();
  final StorageReference storageUsers = baseStorage.child('users');

  Stream<dynamic> savePicture(File file, StorageReference storageReference) {
    return Stream.fromFuture(getImageFirestoreUrl(file, storageReference))
        .map((url) => url);
  }

  Future<String> getImageFirestoreUrl(
      File file, StorageReference storageReference) async {
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String url = await storageTaskSnapshot.ref.getDownloadURL();
    return url;
  }
}
