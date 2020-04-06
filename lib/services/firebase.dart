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
        .listen((AuthResult authResult) {
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
  final baseMsg = base.child('messages');
  final baseDiscussion = base.child('discussions');

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

  void sendMessage(User user, User me, String text, String imageUrl) {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    Map m = {
      'from': me.id,
      'to': user.id,
      'text': text,
      'imageUrl': imageUrl,
      'dateString': date
    };
    baseMsg.child(getMessageRef(me.id, user.id)).child(date).set(m);
    baseDiscussion
        .child(me.id)
        .child(user.id)
        .set(getDiscussion(me.id, user, text, date));
    baseDiscussion
        .child(user.id)
        .child(me.id)
        .set(getDiscussion(me.id, me, text, date));
  }

  Map getDiscussion(
      String sender, User interlocutor, String text, String dateString) {
    Map m = interlocutor.toMap();
    m['myID'] = sender;
    m['lastMsg'] = text;
    m['dateString'] = dateString;
    return m;
  }

  String getMessageRef(String from, String to) {
    String res;
    List<String> l = [from, to];
    l.sort((a, b) => a.compareTo(b));
    for (var x in l) {
      res += x + '+';
    }
    return res;
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
