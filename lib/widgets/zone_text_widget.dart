import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_zone_text.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';

class ZoneTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocZoneText>(context);

    return StreamBuilder<User>(
      stream: bloc.stream,
      builder: (_, snap) {
        if (snap.hasData) {
          final interlocutor = snap.data;
          return Container(
            color: Colors.grey[300],
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.camera_enhance), onPressed: null),
                IconButton(icon: Icon(Icons.photo_library), onPressed: null),
                Flexible(
                  child: TextField(
                    controller: bloc.textEditingController,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Write something...'),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: bloc.sendButtonPressed()),
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
