import 'package:flutter/material.dart';
import 'bubble_type.dart';

class ChatBubble extends StatelessWidget {
  final senderColour = #ADD8E6;
  final receiverColour = #D3D3D3;

  final String text;
  final BubbleType type;
  final UniqueKey uniqueKey;

  ChatBubble({this.text, this.type, this.uniqueKey});

  @override
  Widget build(BuildContext context) {
    // Receiver card to the left.
    if (type == BubbleType.receiver) {
      return Container(
        key: uniqueKey,
        alignment: Alignment.topLeft,
        child: Card(
          elevation: 2,
          color: Colors.grey[350],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          ),
        ),
      );
    }
    // Sender card to the right.
    else {
      return Container(
        key: uniqueKey,
        alignment: Alignment.topRight,
        child: Card(
          elevation: 2,
          color: Colors.lightBlue[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          ),
        ),
      );
    }
  }
}
