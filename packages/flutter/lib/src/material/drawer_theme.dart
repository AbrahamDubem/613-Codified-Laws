// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'theme.dart';

// Examples can assume:
// late BuildContext context;

/// Defines default property values for descendant [Drawer] widgets.
///
/// Descendant widgets obtain the current [DrawerThemeData] object
/// using `DrawerTheme.of(context)`. Instances of [DrawerThemeData] can be
/// customized with [DrawerThemeData.copyWith].
///
/// Typically a [DrawerThemeData] is specified as part of the
/// overall [Theme] with [ThemeData.drawerTheme].
///
/// All [DrawerThemeData] properties are `null` by default.
///
/// See also:
///
///  * [DrawerTheme], an [InheritedWidget] that propagates the theme down its
///    subtree.
///  * [ThemeData], which describes the overall theme information for the
///    application and can customize a drawer using [ThemeData.drawerTheme].
@immutable
class DrawerThemeData with Diagnosticable {
  /// Creates a theme that can be used for [ThemeData.drawerTheme] and
  /// [DrawerTheme].
  const DrawerThemeData({
    this.backgroundColor,
    this.scrimColor,
    this.elevation,
    this.shape,
    this.width,
  });

  /// Overrides the default value of [Drawer.backgroundColor].
  final Color? backgroundColor;

  /// Overrides the default value of [DrawerController.scrimColor].
  final Color? scrimColor;

  /// Overrides the default value of [Drawer.elevation].
  final double? elevation;

  /// Overrides the default value of [Drawer.shape].
  final ShapeBorder? shape;

  /// Overrides the default value of [Drawer.width].
  final double? width;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  DrawerThemeData copyWith({
    Color? backgroundColor,
    Color? scrimColor,
    double? elevation,
    ShapeBorder? shape,
    double? width,
  }) {
    return DrawerThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      scrimColor: scrimColor ?? this.scrimColor,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      width: width ?? this.width,
    );
  }

  /// Linearly interpolate between two drawer themes.
  ///
  /// If both arguments are null then null is returned.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static DrawerThemeData? lerp(DrawerThemeData? a, DrawerThemeData? b, double t) {
    assert(t != null);
    if (a == null && b == null) {
      return null;
    }
    return DrawerThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      scrimColor: Color.lerp(a?.scrimColor, b?.scrimColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
      width: lerpDouble(a?.width, b?.width, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    scrimColor,
    elevation,
    shape,
    width,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DrawerThemeData
        && other.backgroundColor == backgroundColor
        && other.scrimColor == scrimColor
        && other.elevation == elevation
        && other.shape == shape
        && other.width == width;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(ColorProperty('scrimColor', scrimColor, defaultValue: null));
    properties.add(DoubleProperty('elevation', elevation, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DoubleProperty('width', width, defaultValue: null));
  }
}

/// An inherited widget that defines visual properties for [Drawer]s in this
/// widget's subtree.
///
/// Values specified here are used for [Drawer] properties that are not
/// given an explicit non-null value.
///
/// Using this would allow you to override the [ThemeData.drawerTheme].
class DrawerTheme extends InheritedTheme {
  /// Creates a theme that defines the [DrawerThemeData] properties for a
  /// [Drawer].
  const DrawerTheme({
    super.key,
    required this.data,
    required super.child,
  }) : assert(data != null);

  /// Specifies the background color, scrim color, elevation, and shape for
  /// descendant [Drawer] widgets.
  final DrawerThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [DrawerTheme] widget, then
  /// [ThemeData.drawerTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// DrawerThemeData theme = DrawerTheme.of(context);
  /// ```
  static DrawerThemeData of(BuildContext context) {
    final DrawerTheme? drawerTheme = context.dependOnInheritedWidgetOfExactType<DrawerTheme>();
    return drawerTheme?.data ?? Theme.of(context).drawerTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DrawerTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DrawerTheme oldWidget) => data != oldWidget.data;
}
