import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/models/message.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/widgets/image_widget.dart';

class BubbleWidget extends StatelessWidget {
  final Message message;
  final User interlocutor;
  final String myID;
  final Animation animation;

  const BubbleWidget({
    Key key,
    this.message,
    this.interlocutor,
    this.myID,
    this.animation,
  }) : super(key: key);

  List<Widget> widgetsBubble(bool isMe) {
    CrossAxisAlignment alignment =
        (isMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color bubbleColor = (!isMe) ? Colors.blue[400] : Colors.pink[100];
    Color textColor = (isMe) ? Colors.black : Colors.grey[200];

    return <Widget>[
      (isMe)
          ? Padding(padding: EdgeInsets.all(8.0))
          : ImageWidget(
              imageUrl: interlocutor.imageUrl,
              initials: interlocutor.initials,
              radius: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: alignment,
          children: <Widget>[
            Text(message.dateString),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: bubbleColor,
              child: Container(
                padding: EdgeInsets.all(10),
                child: (message.imageUrl == null)
                    ? Text(
                        message.text ?? '',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : ImageWidget(
                        imageUrl: message.imageUrl,
                        initials: null,
                        radius: null),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widgetsBubble(message.from == myID),
        ),
      ),
    );
  }
}
