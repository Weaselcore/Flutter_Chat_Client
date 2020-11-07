import 'package:flutter/material.dart';
import 'package:flutter_websocket_site/bubble_type.dart';
import 'package:flutter_websocket_site/chat_bubble.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/painting.dart';
import 'json_message_types.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(
        title: 'Python2Flutter Chat Service',
        channel: WebSocketChannel.connect(Uri.parse('ws://localhost:5502')),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, this.title, this.channel}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  ScrollController _listScrollController = ScrollController();
  JsonMessageHandler jsonConverter = JsonMessageHandler();
  FocusNode messageFocusNode;

  List oldMessageList = [];
  List globalMessageList = [];
  bool hasMessage = false;
  var _name = "Guest";

  @override
  void initState() {
    super.initState();
    messageFocusNode = FocusNode();
    // Modifies the startup procedure for this app.
    //If needed, initialise things here.
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.blueGrey[100],
      body: Column(
        children: [
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: screenSize.height * 0.04,
                        width: screenSize.width * 0.85,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onFieldSubmitted: (string) {
                                  if (string.isNotEmpty) {
                                    setState(() {
                                      _name = string;
                                      print('name has been changed to $string');
                                      _nameController.clear();
                                    });
                                  }
                                },
                                controller: _nameController,
                                decoration: InputDecoration(labelText: "Name:"),
                                maxLines: 1,
                              ),
                            ),
                            ElevatedButton(
                              child: Text("Set Name"),
                              onPressed: _setName,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      height: screenSize.height * 0.70,
                      width: screenSize.width * 0.70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: widget.channel.stream,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              globalMessageList.add(snapshot.data);
                              return ListView.builder(
                                itemCount: globalMessageList.length,
                                controller: _listScrollController,
                                itemBuilder: (BuildContext ctx, int index) {
                                  hasMessage = true;
                                  print(snapshot.data.toString());
                                  print(snapshot.data
                                      .toString()
                                      .startsWith(_name));
                                  if (snapshot.data
                                      .toString()
                                      .startsWith(_name)) {
                                    return ChatBubble(
                                      text: jsonConverter.jsonConvert(
                                          globalMessageList[index]),
                                      type: BubbleType.sender,
                                      uniqueKey: UniqueKey(),
                                    );
                                  } else {
                                    return ChatBubble(
                                      text: jsonConverter.jsonConvert(
                                          globalMessageList[index]),
                                      type: BubbleType.receiver,
                                      uniqueKey: UniqueKey(),
                                    );
                                  }

                                  // ListTile(
                                  //   title: Text(globalMessageList[index]),
                                  // );
                                },
                              );
                            } else {
                              return Container(
                                child: Text(
                                  "Use the textfield above to set your name.",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onFieldSubmitted: (string) {
                    if (string.isNotEmpty) {
                      String newMessage = '$_name: $string';
                      widget.channel.sink.add(newMessage);
                      _messageController.clear();
                      messageFocusNode.requestFocus();

                      if (hasMessage)
                        _listScrollController.animateTo(
                            (_listScrollController.position.maxScrollExtent +
                                500.0),
                            curve: Curves.easeOut,
                            duration: Duration(seconds: 1));
                    }
                  },
                  controller: _messageController,
                  autofocus: true,
                  maxLines: 1,
                  focusNode: messageFocusNode,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '$_name',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        child: Icon(Icons.send),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    messageFocusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      String newMessage = '$_name: ${_messageController.text}';
      widget.channel.sink.add(newMessage);
      _messageController.clear();
      messageFocusNode.requestFocus();

      if (hasMessage)
        _listScrollController.animateTo(
            (_listScrollController.position.maxScrollExtent + 50.0),
            curve: Curves.easeOut,
            duration: Duration(seconds: 1));
    }
  }

  void _setName() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _name = _nameController.text;
        print('name has been changed to $_name');
        _nameController.clear();
      });
    }
  }
}
