import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_profile.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/widgets/image_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocProfile>(context);

    return StreamBuilder<User>(
      stream: bloc.userData,
      builder: (_, snap) {
        if (snap.hasData) {
          final User user = snap.data;
          bloc.syncToModel(snap.data);
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // image
                  ImageWidget(
                      imageUrl: user.imageUrl,
                      initials: user.initials,
                      radius: MediaQuery.of(context).size.width / 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera_enhance),
                        onPressed: () {
                          bloc.takePicture(ImageSource.camera);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () {
                          bloc.takePicture(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: user.firstname),
                    onChanged: (String str) {
                      bloc.updateFirstname(str);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: user.lastname),
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
