import 'dart:io';

import '../objects/Factor.dart';

import 'Window.dart';
import 'package:flutter/material.dart';

class OManager {
  static final List<Window> presetWindows = [
    // Standard Window
    Window(
      name: 'Sliding',
      duration: Duration(minutes: 10),
      price: 12.50,
      image: File(
        'assets/images/standard_window.png',
      ),
    ),

    // French Window
    Window(
      name: 'French',
      duration: Duration(minutes: 15),
      price: 16,
      image: File(
        'assets/images/french_window.png',
      ),
    ),

    // Casement Window
    Window(
      name: 'Casement',
      duration: Duration(minutes: 6, seconds: 30),
      price: 11,
      image: File(
        'assets/images/casement_window.png',
      ),
    ),

    // Picture Window
    Window(
      name: 'Picture',
      duration: Duration(minutes: 6),
      price: 11,
      image: File(
        'assets/images/picture_window.png',
      ),
    ),

    // Garden Window
    Window(
      name: 'Garden',
      duration: Duration(minutes: 20),
      price: 20,
      image: File(
        'assets/images/garden_window.png',
      ),
    ),

    // Solar Panel
    Window(
      name: 'Solar Panel',
      duration: Duration(minutes: 5),
      price: 5,
      image: File('assets/images/solar_panel.png'),
    )
  ];

  static getAll() {
    return presetWindows;
  }

  static Window getDefaultWindow() {
    return presetWindows[0];
  }

  static getFactorInstance(Factors type) {
    return factorList[type].copy();
  }

  static final Map<Factors, Factor> factorList = {
    // construction clean up
    Factors.construction: Factor(
      factorKey: Factors.construction,
      name: 'Construction Clean Up',
      priceMultiplier: 2.0,
      durationMultiplier: 2.0,
      image: Image.asset('assets/images/construction_factor.png'),
    ),

    // one side being cleaned
    Factors.sided: Factor(
      factorKey: Factors.sided,
      name: 'Sided',
      priceMultiplier: .6,
      durationMultiplier: .6,
      image: Image.asset('assets/images/sided_factor.png'),
    ),

    // difficult to clean
    Factors.difficult: Factor(
      factorKey: Factors.difficult,
      name: 'Difficult',
      priceMultiplier: 1.5,
      durationMultiplier: 2.0,
      image: Image.asset('assets/images/hazard_factor.png'),
    ),

    // filthy
    Factors.filthy: Factor(
      factorKey: Factors.filthy,
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
