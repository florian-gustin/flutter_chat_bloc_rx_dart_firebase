import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_zone_text.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:image_picker/image_picker.dart';

class ZoneTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocZoneText>(context);

    return StreamBuilder<List<User>>(
      stream: bloc.stream,
      builder: (_, snap) {
        if (snap.hasData) {
          final me = snap.data[0];
          final interlocutor = snap.data[1];
          print(me.firstname);
          print(interlocutor.firstname);
          return Container(
            color: Colors.grey[300],
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.camera_enhance),
                    onPressed: () {
                      bloc.takePicture(ImageSource.camera);
                    }),
                IconButton(
                    icon: Icon(Icons.photo_library),
                    onPressed: () {
                      bloc.takePicture(ImageSource.gallery);
                    }),
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
                    onPressed: () {
                      bloc.sendButtonPressed(context);
                    }),
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
