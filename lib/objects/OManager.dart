import 'dart:io';

import '../objects/Factor.dart';

import 'Setting.dart';
import 'Window.dart';
import 'package:flutter/material.dart';

class OManager {
  static final List<Window> presetWindows = [
    // Standard Window
    Window(
      name: 'Sliding',
      duration: Duration(minutes: 10),
      price: 12.50,
      image: File('assets/images/standard_window.png'),
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

    // Commercial Window
    Window(
      name: 'Commercial',
      duration: Duration(minutes: 3, seconds: 30),
      price: 6,
      image: File(
        'assets/images/comm_window.png',
      ),
    ),

    // Windwall Window
    Window(
      name: 'Windwall',
      duration: Duration(minutes: 2, seconds: 30),
      price: 5,
      image: File(
        'assets/images/windwall.png',
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

  static Factor getFactorInstance(Factors type) {
    return factorList[type].copy();
  }

  static final Map<Factors, Factor> factorList = {
    // construction clean up
    Factors.construction: Factor(
      factorKey: Factors.construction,
      name: 'Construction Clean Up',
      priceMultiplier: 2.0,
      durationMultiplier: 2.0,
      image: Image.asset(
        'assets/images/construction_factor.png',
        semanticLabel: 'Construction Clean Up',
      ),
    ),

    // one side being cleaned
    Factors.sided: Factor(
      factorKey: Factors.sided,
      name: 'Sided',
      priceMultiplier: .6,
      durationMultiplier: .6,
      image: Image.asset(
        'assets/images/sided_factor.png',
        semanticLabel: 'Exterior Only',
      ),
    ),

    // difficult to clean
    Factors.difficult: Factor(
      factorKey: Factors.difficult,
      name: 'Difficult',
      priceMultiplier: 1.5,
      durationMultiplier: 2.0,
      image: Image.asset(
        'assets/images/hazard_factor.png',
        semanticLabel: 'inaccessible',
      ),
    ),

    // filthy
    Factors.filthy: Factor(
      factorKey: Factors.filthy,
      name: 'Filthy',
      priceMultiplier: 1.75,
      durationMultiplier: 2.0,
      image: Image.asset(
        'assets/images/filthy_factor.png',
        semanticLabel: 'Extra Dirty',
      ),
    ),
  };
}

enum Factors {
  construction,
  sided,
  difficult,
  filthy,
}

/// The symbol used to display the currency
final Setting preferredCurrencySymbol = Setting(
  title: 'Currency Symbol',
  editable: true,
  value: '\$',
);

/// Techdetails which allows the user to change the values calculated
final Map<TechDetails, Setting> techDetailsList = {
  TechDetails.targetProduction: Setting(
    title: 'Hourly Rate',
    editable: true,
    value: 85.0,
  ),
  TechDetails.driveTime: Setting(
    title: 'Added Fixed Cost',
    editable: true,
    value: 25.0,
  ),
  TechDetails.minPrice: Setting(
    title: 'Minimum Price',
    editable: true,
    value: 100.0,
  ),
};

enum TechDetails {
  targetProduction,
  driveTime,
  minPrice,
}
