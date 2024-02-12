import 'package:flutter/material.dart';
import 'package:flutter_chess_puzzle/gameboard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Chess Puzzle"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      body: const GameBoard(),
      drawer: const DrawerWidget(title: 'Left Drawer'),
      endDrawer: const DrawerWidget(title: 'Right Drawer'),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  final String title;
  const DrawerWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(title),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          // Additional items here
        ],
      ),
    );
  }
}
