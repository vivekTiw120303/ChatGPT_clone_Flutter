import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import 'Chat_Messages.dart';
import 'ThreeDots.dart';

class ChatScreen extends StatefulWidget{
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }

}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _controller = TextEditingController();

  final List<ChatMessages> _messages = [];

  bool _isTyping = false;

  ChatGPT? chatGPT;
  StreamSubscription? _subscription;

  @override
  void initState() {
    chatGPT = ChatGPT.instance;
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessages message = ChatMessages(text: _controller.text, sender: 'user');

    setState(() {
      _isTyping =true;
      _messages.insert(0, message);
    });

    _controller.clear();

    final request = CompleteReq(
        prompt: message.text, model: kTranslateModelV3, max_tokens: 200);

    // token here is your API key. 
    // You can find your API key at https://beta.openai.com/account/api-keys
    
    _subscription = chatGPT!.builder(
        "token", orgId: "")
        .onCompleteStream(request: request)
        .listen((response) {
      ChatMessages botMessage = ChatMessages(
          text: response!.choices[0].text,
          sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    }
    );
  }

  Widget _textComponent(){
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => _sendMessage(),
              decoration: const InputDecoration.collapsed(hintText: 'Write a Message'),
            ),
          ),
        ),
        IconButton(onPressed: (){
          return _sendMessage();
        }, icon: const Icon(Icons.send))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : const Center(child: Text('ChatGPT Page'))),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index){
                    return _messages[index];
                  }),
              ),

            if(_isTyping) const ThreeDots(),

            const Divider(height: 2.0, thickness: 2.0,),

            Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
              ),
              child: _textComponent(),
            )
          ],
        ),
      ),
    );
  }
}
