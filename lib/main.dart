import 'package:flutter/material.dart';
import 'package:flutter_test_project/color_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: BlocProvider(
          create: (context) => ColorBloc(),
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorBloc _bloc = BlocProvider.of<ColorBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('BLoC with flutter'),
        centerTitle: true,
      ),
      body: Center(
        child: BlocBuilder<ColorBloc, Color>(
          builder: (contxt, currentColor) => AnimatedContainer(
            height: 100,
            width: 100,
            color: currentColor,
            duration: const Duration(milliseconds: 500),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                _bloc.add(ColorEvent.event_red);
              }),
          const SizedBox(width: 10),
          FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                _bloc.add(ColorEvent.event_green);
              }),
        ],
      ),
    );
  }
}
