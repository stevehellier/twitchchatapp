import 'package:flutter/material.dart';
import 'package:twitch_chat/twitch_chat.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyMainAppState();
  }
}

class Message {
  String username;
  String content;

  Message(this.username, this.content);
}

class MyMainAppState extends State<MainApp> {
  var title = "Twitch Chat App";
  final scrollController = ScrollController();
  final List<Message> messages = [];
  var channelName = "bobross";
  late TwitchChat twitchChat;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("INIT STATE!");
    connectToTwitch();
  }

  void connectToTwitch() {
    twitchChat = TwitchChat(channelName, 'justinfan1243', '', onConnected: () {
      print("connected to $channelName");
    }, onError: (error) {
      print("Error connecting to $channelName - $error");
    });
    twitchChat.connect();

    twitchChat.chatStream.listen((message) {
      var chatMessage = message as ChatMessage;
      addMessage(Message(chatMessage.displayName, chatMessage.message));
    });
  }

  void changeChannel(String name) {
    if (name.isNotEmpty) {
      setState(() {
        channelName = name;
      });

      if (twitchChat.isConnected.value) {
        print("changing to $name");
        twitchChat.changeChannel(channelName);
      } else {
        print("connecting to Twitch");
        connectToTwitch();
      }
      myController.text = "";
      messages.clear();
    }
  }

  void addMessage(Message message) {
    setState(() {
      messages.add(message);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  void doSubmit() {
    changeChannel(myController.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: myController,
                decoration:
                    const InputDecoration(hintText: 'Enter a channel name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a channel name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  if (myController.value.text.isNotEmpty) {
                    doSubmit();
                  }
                },
                child: Text(
                  'Change Channel',
                  style: Theme.of(context).primaryTextTheme.labelSmall,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final item = messages[index];

                    return Card(
                      child: ListTile(
                        title: Text(item.username),
                        subtitle: Text(item.content),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class FormViewHomeLayout extends StatefulWidget {
  const FormViewHomeLayout({super.key});

  @override
  FormViewHome createState() {
    return FormViewHome();
  }
}

class FormViewHome extends State<FormViewHomeLayout> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration:
                  const InputDecoration(hintText: 'Enter a channel name'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a channel name';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //
                  }
                },
                child: const Text('Submit'),
              ),
            )
          ],
        ));
  }
}

class ListViewHomeLayout extends StatefulWidget {
  const ListViewHomeLayout({super.key});

  @override
  ListViewHome createState() {
    return ListViewHome();
  }
}

class ListViewHome extends State<ListViewHomeLayout> {
  var title = "Twitch Chat App";
  final scrollController = ScrollController();
  final List<Message> messages = [];
  var channelName = "purplelf";
  late TwitchChat twitchChat;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final item = messages[index];

          return ListTile(
            title: Text(item.username),
            subtitle: Text(item.content),
          );
        });
  }
}
/*

ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final item = _messages[index];

                return ListTile(
                  title: Text(item.username),
                  subtitle: Text(item.content),
                );
              }),

InputDatePickerFormField(
            firstDate: DateTime.now(),
            initialDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 50),
          ),

*/