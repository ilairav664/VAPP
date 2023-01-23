import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
class MeScreen extends StatelessWidget{
  Widget build(BuildContext context) {
    return Center(child: Column(
        children: [
      ElevatedButton(
      style: globals.buttonStyle,
      onPressed: () {
        Navigator.pushNamed(
            context,
            '/measureRoute'
        );
      },
      child: const Text('ИЗМЕРЕНИЕ'),
    )])
    );
  }
}