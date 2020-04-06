import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_chat.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_router.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/widgets/image_widget.dart';
import 'package:flutter_chat_bloc_rxdart/widgets/zone_text_widget.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocChat>(context);

    return StreamBuilder<User>(
      stream: bloc.stream,
      builder: (_, snap) {
        if (snap.hasData) {
          final interlocutor = snap.data;
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ImageWidget(
                    imageUrl: interlocutor.imageUrl,
                    initials: interlocutor.initials,
                    radius: 15.0,
                  ),
                  Text(interlocutor.firstname)
                ],
              ),
            ),
            body: Container(
              child: InkWell(
                // close keyboard
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Column(
                  children: <Widget>[
                    // Chat
                    Flexible(child: Container()),
                    Divider(
                      height: 1.5,
                    ),
                    // divider
                    BlocRouter().zoneText(
                        id: bloc.id,
                        user: interlocutor,
                        child: ZoneTextWidget()),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text('This user no longer exists...'),
          );
        }
      },
    );
  }
}
