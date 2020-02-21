import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'light_source.dart';

class NeumorphicColors {
  static const background = Color(0xffF1F2F4);

  /// Generate a shadow color from the [base] color and a relative [intensity].
  /// Positive intensity denotes a darker shade while negative intensity
  /// denotes a lighter shade.
  /// Credit for the algorithm goes to https://neumorphism.io
  static Color generateGradientColors(
      {Color colorBase, double intensity, bool updateAlpha = true}) {
    final t = intensity ?? 0;
    String e = colorBase.value.toRadixString(16).substring(2);
    if (e.length < 6) e = e[0] + e[0] + e[1] + e[1] + e[2] + e[2];
    String o = '';
    for (int n = 0; n < 3; n++) {
      var a = int.parse(e.substring(2 * n, 2 * n + 2), radix: 16);
      a = min(max(0, (a + a * t).round()), 255);
      o += ('00' + a.toRadixString(16)).substring(a.toRadixString(16).length);
    }

    final generatedColor = Color(int.parse(o, radix: 16));
    if (updateAlpha) {
      return generatedColor.withAlpha(255);
    } else {
      return generatedColor;
    }
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Gradient generateEmbossGradients(
      {@required LightSource source, @required Color color}) {
    var begin;
    var end;

    if (source == LightSource.bottomLeft) {
      begin = Alignment.bottomLeft;
      end = Alignment.topRight;
    } else if (source == LightSource.topLeft) {
      begin = Alignment.topLeft;
      end = Alignment.bottomRight;
    } else if (source == LightSource.topRight) {
      begin = Alignment.topRight;
      end = Alignment.bottomLeft;
    } else if (source == LightSource.bottomRight) {
      begin = Alignment.bottomRight;
      end = Alignment.topLeft;
    } else if (source == LightSource.top) {
      begin = Alignment.topCenter;
      end = Alignment.bottomCenter;
    } else if (source == LightSource.left) {
      begin = Alignment.centerLeft;
      end = Alignment.centerRight;
    } else if (source == LightSource.right) {
      begin = Alignment.centerRight;
      end = Alignment.centerLeft;
    } else if (source == LightSource.bottom) {
      begin = Alignment.bottomCenter;
      end = Alignment.topCenter;
    }

    return LinearGradient(begin: begin, end: end, colors: [
      color,
      color,
    ]);
  }

  static Gradient generateFlatGradients({Color color}) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          color,
        ],
      );

  static Color getAdjustColor(Color baseColor, double amount) {
    Map<String, int> colors = {
      'r': baseColor.red,
      'g': baseColor.green,
      'b': baseColor.blue
    };

    colors = colors.map((key, value) {
      if (value + amount < 0) {
        return MapEntry(key, 0);
      }
      if (value + amount > 255) {
        return MapEntry(key, 255);
      }
      return MapEntry(key, (value + amount).floor());
    });
    return Color.fromRGBO(colors['r'], colors['g'], colors['b'], 1);
  }
}
