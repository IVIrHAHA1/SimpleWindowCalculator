import 'package:flutter/material.dart';

class WindowPallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.blue,
        width: MediaQuery.of(context).size.width / 2,
        child: Text('hello there gorgous!'),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
