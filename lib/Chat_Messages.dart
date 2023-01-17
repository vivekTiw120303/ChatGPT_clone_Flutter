import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessages extends StatelessWidget{

  const ChatMessages({super.key, required this.text, required this.sender,});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text(sender)
        .text
        .subtitle1(context)
        .make()
        .box.color(sender=="user" ? Vx.red200 : Vx.green200).border(color: Colors.orange.shade100, width: 2)
        .p16
        .rounded
        .alignCenter
        .makeCentered(),

        Expanded(
            child: text.trim().text.bodyText1(context).make().px8(),
        )

      ], // children
    ).py8();

  } // build

} // ChatMessage