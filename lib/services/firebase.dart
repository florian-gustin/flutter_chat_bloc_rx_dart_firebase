import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Firebase {
  // auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get onAuthStateChanged {
    return auth.onAuthStateChanged.map((FirebaseUser user) => user);
  }

  Stream<FirebaseUser> handleSignIn(String mail, String password) => auth
      .signInWithEmailAndPassword(email: mail, password: password)
      .asStream()
      .map((AuthResult authResult) => authResult?.user);

  Stream<FirebaseUser> handleCreate(
      String mail, String password, String firstname, String lastname) {
    auth
        .createUserWithEmailAndPassword(email: mail, password: password)
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

  Stream<void> get handleSignOut => auth.signOut().asStream();

  Stream<String> get userUID =>
      auth.currentUser().asStream().map((FirebaseUser user) => user?.uid);

  // db
  static final base = FirebaseDatabase.instance.reference();
  final baseUser = base.child('users');

  addUser(String uid, Map map) {
    baseUser.child(uid).set(map);
  }

  Stream<DataSnapshot> getUserData(String id) {
    return baseUser
        .child(id)
        .once()
        .asStream()
        .map((DataSnapshot dataSnapshot) => dataSnapshot);
  }

  Firebase();
}
