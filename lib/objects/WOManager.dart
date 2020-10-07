import './Window.dart';
import 'package:flutter/material.dart';

class WOManager {
  static final List<Window> windows = [
    // Standard Window
    Window(
      name: 'Standard Window',
      duration: Duration(minutes: 10),
      price: 12,
      image: Image.asset('assets/images/standard_window.png',
        height: 100,),
    ),

    // French Window
    Window(
      name: 'French Window',
      duration: Duration(minutes: 15),
      price: 16,
      image: Image.asset(
        'assets/images/french_window.png',
        height: 100,
      ),
    ),

    // Casement Window
    Window(
      name: 'Casement Window',
      duration: Duration(minutes: 6),
      price: 8,
      image: Image.asset('assets/images/standard_window.png',
        height: 100,),
    ),

    // Picture Window
    Window(
      name: 'Picture Window',
      duration: Duration(minutes: 5),
      price: 8,
      image: Image.asset('assets/images/standard_window.png',
        height: 100,),
    ),

    // Louvers
    Window(
      name: 'Louvers',
      duration: Duration(minutes: 20),
      price: 16,
      image: Image.asset('assets/images/standard_window.png',
        height: 100,),
    ),
  ];

  static getAll() {
    return windows;
  }
}
