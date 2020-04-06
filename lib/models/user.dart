import 'package:firebase_database/firebase_database.dart';

class User {
  bool isLog = true;
  String id;
  String mail;
  String password;
  String firstname;
  String lastname;

  String imageUrl;
  String initials;

  String status;

  User();

  User.fromMap(DataSnapshot snapshot) {
    Map<dynamic, dynamic> map = snapshot.value;
    id = map['uid'];
    firstname = map['firstname'];
    lastname = map['lastname'];
    imageUrl = map['imageUrl'];
    if (firstname != null && firstname.length > 0) initials = firstname[0];
    if (lastname != null && lastname.length > 0 && initials != null)
      initials += lastname[0];
  }

  Map toMap() {
    return {
      'uid': id,
      'firstname': firstname,
      'lastname': lastname,
      'imageUrl': imageUrl,
    };
  }
}
