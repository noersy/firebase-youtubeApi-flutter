import 'package:challenge_intern_veturo/providers/main_providers.dart';
import 'package:challenge_intern_veturo/view/screen_one.dart';
import 'package:challenge_intern_veturo/view/screen_two.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainProviders(),
        ),
      ],
      child: const MaterialApp(
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _userName = "Venturo User";
  final String _userEmail = "hello@venturo.id";

  int _index = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    Firebase.initializeApp();
    _screens = [
      ScreenOne(callback: () => _scaffoldKey.currentState?.openDrawer()),
      ScreenTwo(callback: () => _scaffoldKey.currentState?.openDrawer()),
    ];
    super.initState();
  }

  TextStyle get _textStyle => const TextStyle(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.deepPurpleAccent,
              padding: const EdgeInsets.all(12.0).copyWith(top: 42.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ClipRect(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://e7.pngegg.com/pngimages/84/165/png-clipart-united-states-avatar-organization-information-user-avatar-service-computer-wallpaper.png'),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    _userName,
                    style: _textStyle.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    _userEmail,
                    style: _textStyle,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
                setState(() => _index = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.black),
              title: const Text("Materi Pemblajaran"),
              onTap: () {
                Navigator.pop(context);
                setState(() => _index = 1);
              },
            ),
          ],
        ),
      ),
      body: _screens[_index],
    );
  }
}
