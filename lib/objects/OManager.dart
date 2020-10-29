import '../objects/Factor.dart';

import 'Window.dart';
import 'package:flutter/material.dart';

class OManager {
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

  getFactorInstance(Factors type) {
    return factorList[type].copy();
  }

  static final Map<Factors, Factor> factorList = {
    // construction clean up
    Factors.construction: Factor(
      name: 'Construction Clean Up',
      priceMultiplier: 2.0,
      durationMultiplier: 2.0,
      image: Image.asset('assets/images/construction_factor.png'),
    ),

    // one side being cleaned
    Factors.sided: Factor(
      name: 'Sided',
      priceMultiplier: .6,
      durationMultiplier: .6,
      image: Image.asset('assets/images/sided_factor.png'),
    ),

    // difficult to clean
    Factors.difficult: Factor(
      name: 'Difficult',
      priceMultiplier: 1.5,
      durationMultiplier: 2.0,
      image: Image.asset('assets/images/hazard_factor.png'),
    ),

    // filthy
    Factors.filthy: Factor(
      name: 'Filthy',
      priceMultiplier: 1.5,
      durationMultiplier: 2.0,
      image: Image.asset('assets/images/filthy_factor.png'),
    ),
  };
}

enum Factors {
  construction,
  sided,
  difficult,
  filthy,
}
