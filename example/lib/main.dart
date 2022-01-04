import 'package:popup_menu_chat/popup_menu_chat.dart';
import 'package:flutter/material.dart';

import 'chat_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChatModel chatModel = ChatModel();
  List<ChatModel> messages = [];

  @override
  void initState() {
    messages = chatModel.initContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: const Text(
        'Popup Menu Chat Demo',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
      leading: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Icon(
            Icons.music_note_rounded,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0.1,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_horiz_outlined,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: messages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return MessageContent(chatModel: messages[index]);
            },
          ),
        ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildInputBar() {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.emoji_symbols_sharp,
                color: Colors.black54,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Aa',
                  hintMaxLines: 1,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.insert_emoticon_outlined,
                      color: Colors.blueAccent,
                    ),
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageContent({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;
  List menuItems = [];

  Widget _buildLongPressMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildReactionButton(icon: Icons.favorite, color: Colors.redAccent),
          _buildReactionButton(
              icon: Icons.tag_faces_sharp, color: Colors.yellowAccent),
          _buildReactionButton(
              icon: Icons.face_outlined, color: Colors.yellowAccent),
          _buildReactionButton(
              icon: Icons.face_retouching_natural, color: Colors.yellowAccent),
          _buildReactionButton(icon: Icons.add_circle, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildReactionButton({required IconData icon, required Color color}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isSender, double size) {
    return CircleAvatar(
      radius: size,
      backgroundColor: isSender ? Colors.blueAccent : Colors.deepOrangeAccent,
      child: Icon(
        isSender ? Icons.filter_vintage_outlined : Icons.tungsten_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  BorderRadiusGeometry _buildBorderRadius(bool isSender) {
    const radius = Radius.circular(12);
    const radiusForTop = Radius.circular(4);

    return BorderRadius.only(
      topLeft: isSender ? radius : radiusForTop,
      topRight: isSender ? radiusForTop : radius,
      bottomLeft: radius,
      bottomRight: radius,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = chatModel.isSender;
    double avatarSize = 14;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        textDirection: isSender ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: isSender ? 0 : 10,
              left: isSender ? 10 : 0,
            ),
            child: _buildAvatar(isSender, avatarSize),
          ),
          PopupMenuChat(
            child: Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(maxWidth: 240, minHeight: avatarSize),
              decoration: BoxDecoration(
                color: isSender ? Colors.greenAccent : Colors.white,
                borderRadius: _buildBorderRadius(isSender),
              ),
              child: Text(chatModel.content ?? ''),
            ),
            menuBuilder: _buildLongPressMenu(),
            pressType: PressType.longPress,
            verticalMargin: 50,
          )
        ],
      ),
    );
  }
}
