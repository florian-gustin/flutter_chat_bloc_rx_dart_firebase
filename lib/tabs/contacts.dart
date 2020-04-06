import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_contacts.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/widgets/image_widget.dart';

class Contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocContacts>(context);

    return StreamBuilder<User>(
      stream: bloc.stream,
      builder: (_, snap) {
        if (snap.hasData) {
          return FirebaseAnimatedList(
            query: bloc.queryBaseUser,
            sort: (a, b) =>
                a.value['firstname'].compareTo(b.value['firstname']),
            itemBuilder: (_, DataSnapshot snapshot, animation, index) {
              User newUser = User.fromMap(snapshot);
              if (newUser.id == snap.data.id) {
                return SizedBox();
              }
              return ListTile(
                leading: ImageWidget(
                    imageUrl: newUser.imageUrl,
                    initials: newUser.initials,
                    radius: 20.0),
                title: Text('${newUser.firstname}  ${newUser.lastname}'),
                trailing: IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    bloc.goChat(newUser, context);
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text('Contacts'),
          );
        }
      },
    );
  }
}
