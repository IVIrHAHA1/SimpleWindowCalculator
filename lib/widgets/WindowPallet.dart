import 'package:flutter/material.dart';

class WindowPallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width / 2,
      ),
    );
  }
}