import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_profile.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocProfile>(context);

    return StreamBuilder<DataSnapshot>(
      stream: bloc.userData,
      builder: (_, snap) {
        if (snap.hasData) {
          bloc.fromStreamToUser(snap.data);
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // image
                  TextField(
                    decoration: InputDecoration(hintText: bloc.firstname),
                    onChanged: (String str) {
                      bloc.updateFirstname(str);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: bloc.lastname),
                    onChanged: (String str) {
                      bloc.updateLastname(str);
                    },
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      bloc.saveChanges();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      bloc.signOut();
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text('Loading'),
          );
        }
      },
    );
  }
}
