import 'package:flutter/material.dart';

class ColourPalletes {
  ColourPalletes._();

  // with help from https://materialpalettes.com/

  static const MaterialColor red = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xffffeaed),
      100: Color(0xffffcad0),
      200: Color(0xfff79494),
      300: Color(0xffef696a),
      400: Color(_redPrimaryValue),
      500: Color(0xfffe2725),
      600: Color(0xffef1626),
      700: Color(0xffdd0020),
      800: Color(0xffd10018),
      900: Color(0xffc1000a),
    },
  );
  static const int _redPrimaryValue = 0xfff94144;

  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xffe3f6f8),
      100: Color(0xffb7e7ee),
      200: Color(0xff8cd6e5),
      300: Color(0xff67c6dc),
      400: Color(0xff4fbad8),
      500: Color(0xff3daed4),
      600: Color(0xff34a0c6),
      700: Color(0xff2a8eb4),
      800: Color(_bluePrimaryValue),
      900: Color(0xff1c5d80),
    },
  );
  static const int _bluePrimaryValue = 0xff277da1;

  static const MaterialColor teal = MaterialColor(
    _tealPrimaryValue,
    <int, Color>{
      50: Color(0xffe1f3ee),
      100: Color(0xffb7e1d4),
      200: Color(0xff8aceb9),
      300: Color(0xff5fba9e),
      400: Color(_tealPrimaryValue),
      500: Color(0xff329a79),
      600: Color(0xff2e8d6e),
      700: Color(0xff287d5f),
      800: Color(0xff216d51),
      900: Color(0xff185138),
    },
  );
  static const int _tealPrimaryValue = 0xff43aa8b;

  static const MaterialColor green = MaterialColor(
    _greenPrimaryValue,
    <int, Color>{
      50: Color(0xffeff6ea),
      100: Color(0xffd6e8c9),
      200: Color(0xffbcd8a7),
      300: Color(0xffa3c986),
      400: Color(_greenPrimaryValue),
      500: Color(0xff7eb356),
      600: Color(0xff71a44d),
      700: Color(0xff5f9043),
      800: Color(0xff4e7c3a),
      900: Color(0xff305b28)
    },
  );
  static const int _greenPrimaryValue = 0xff90be6d;

  static const MaterialColor darkerTeal = MaterialColor(
    _darkerTealPrimaryValue,
    <int, Color>{
      50: Color(0xffe3f1f2),
      100: Color(0xffbaddde),
      200: Color(0xff90c7c8),
      300: Color(0xff6bb1b1),
      400: Color(0xff57a1a0),
      500: Color(_darkerTealPrimaryValue),
      600: Color(0xff488381),
      700: Color(0xff427370),
      800: Color(0xff3e6360),
      900: Color(0xff354744),
    },
  );
  static const int _darkerTealPrimaryValue = 0xff4d908e;

  static const MaterialColor yellow = MaterialColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: Color(0xfffffeea),
      100: Color(0xfffefaca),
      200: Color(0xfffdf6a8),
      300: Color(0xfffcf186),
      400: Color(0xfffaec6c),
      500: Color(0xfff7e756),
      600: Color(0xfffddd58),
      700: Color(_yellowPrimaryValue),
      800: Color(0xfff5af47),
      900: Color(0xffed8a39),
    },
  );
  static const int _yellowPrimaryValue = 0xfff9c74f;

  static const MaterialColor orange = MaterialColor(
    _orangePrimaryValue,
    <int, Color>{
      50: Color(0xfffff3e1),
      100: Color(0xfffee0b3),
      200: Color(0xfffdcc83),
      300: Color(0xfffdb652),
      400: Color(0xfffca72e),
      500: Color(_orangePrimaryValue),
      600: Color(0xfff88c13),
      700: Color(0xfff17c12),
      800: Color(0xffeb6d10),
      900: Color(0xffe1540e),
    },
  );
  static const int _orangePrimaryValue = 0xfffc9815;

  static const MaterialColor tamarind = MaterialColor(
    _tamarindPrimaryValue,
    <int, Color>{
      50: Color(0xfffef3e1),
      100: Color(0xfffddfb4),
      200: Color(0xfffcca84),
      300: Color(0xfffab554),
      400: Color(0xfff9a533),
      500: Color(_tamarindPrimaryValue),
      600: Color(0xfff48a1c),
      700: Color(0xffed7b1a),
      800: Color(0xffe76c18),
      900: Color(0xffdc5415),
    },
  );
  static const int _tamarindPrimaryValue = 0xfff8961e;

  static const MaterialColor grey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      350: Color(0xFFD6D6D6),
      400: Color(0xFFBDBDBD),
      500: Color(_greyPrimaryValue),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      850: Color(0xFF303030),
      900: Color(0xFF212121),
    },
  );
  static const int _greyPrimaryValue = 0xFF9E9E9E;

  static const MaterialColor blueGrey = MaterialColor(
    _blueGreyPrimaryValue,
    <int, Color>{
      50: Color(0xffe6effb),
      100: Color(0xffc6d6e4),
      200: Color(0xffa7bacc),
      300: Color(0xff879eb4),
      400: Color(0xff6f89a2),
      500: Color(_blueGreyPrimaryValue),
      600: Color(0xff4a677f),
      700: Color(0xff3b5468),
      800: Color(0xff2d4153),
      900: Color(0xff1b2d3b),
    },
  );
  static const int _blueGreyPrimaryValue = 0xff577590;

  static const List<MaterialColor> pallete1 = <MaterialColor>[
    red,
    blue,
    teal,
    green,
    darkerTeal,
    yellow,
    orange,
    blueGrey,
  ];
}
