import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_messages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_router.dart';
import 'package:flutter_chat_bloc_rxdart/models/discussion.dart';
import 'package:flutter_chat_bloc_rxdart/widgets/image_widget.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocMessages>(context);

    return FirebaseAnimatedList(
      query: bloc.query,
      sort: (a, b) => b.value['dateString'].compareTo(a.value['dateString']),
      itemBuilder: (context, DataSnapshot snapshot, animation, index) {
        Discussion discussion = Discussion(snapshot: snapshot);
        String subtitle = (discussion.id == bloc.id) ? 'Me : ' : '';
        subtitle += discussion.lastMsg ?? 'image sent';
        return ListTile(
          leading: ImageWidget(
              imageUrl: discussion.user.imageUrl,
              initials: discussion.user.initials,
              radius: 20.0),
          title:
              Text('${discussion.user.firstname} ${discussion.user.lastname}'),
          subtitle: Text(subtitle),
          trailing: Text(discussion.date),
          onTap: () => BlocRouter().chat(
              id: bloc.id, interlocutor: discussion.user, context: context),
        );
      },
    );

//    return StreamBuilder(
//      stream: bloc.stream,
//      builder: (_, snap) {
//        if (snap.hasData) {
//
//        } else {
//          return SizedBox();
//        }
//      },
//    );
  }
}
