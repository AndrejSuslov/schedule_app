import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.red),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('some shiiiiiit'),
            //const Icon(Icons.access_alarm_sharp),
            centerTitle: true,
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('some'),
                  TextButton(onPressed: () {}, child: Text('Presss me')),
                ],
              ),
              Column(
                children: [
                  Text('some'),
                  TextButton(onPressed: () {}, child: Text('Presss me')),
                ],
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Text('Press me'),
            backgroundColor: Colors.black,
            onPressed: () {
              print('You clicked');
            },
          ),
        ));
  }
}
