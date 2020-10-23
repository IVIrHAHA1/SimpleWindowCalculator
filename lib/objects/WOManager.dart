import './Window.dart';
import 'package:flutter/material.dart';

class WOManager {
  static final List<Window> windows = [
    // Standard Window
    Window(
      name: 'Sliding',
      duration: Duration(minutes: 10),
      price: 12.50,
      image: Image.asset(
        'assets/images/standard_window.png',
      ),
    ),

    // French Window
    Window(
      name: 'French',
      duration: Duration(minutes: 15),
      price: 16,
      image: Image.asset(
        'assets/images/french_window.png',
      ),
    ),

    // Casement Window
    Window(
      name: 'Casement',
      duration: Duration(minutes: 6),
      price: 8,
      image: Image.asset(
        'assets/images/casement_window.png',
      ),
    ),

    // Picture Window
    Window(
      name: 'Picture',
      duration: Duration(minutes: 5),
      price: 8,
      image: Image.asset(
        'assets/images/picture_window.png',
      ),
    ),

    // Garden Window
    Window(
      name: 'Garden',
      duration: Duration(minutes: 20),
      price: 20,
      image: Image.asset(
        'assets/images/garden_window.png',
      ),
    ),
  ];

  static getAll() {
    return windows;
  }

  static Window getDefaultWindow() {
    return windows[0];
  }
}
