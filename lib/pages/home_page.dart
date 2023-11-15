import 'package:flutter/material.dart';
import 'package:locainfo/components/my_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Home Page',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 88),
          children: const [Text('sdadk')],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Create',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}
