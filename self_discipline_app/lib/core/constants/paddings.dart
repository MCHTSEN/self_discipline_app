import 'package:flutter/material.dart';

enum ProjectRadiusType {
  defaultRadius(24),
  smallRadius(4),
  mediumRadius(8),
  normalRadius(12),
  largeRadius(16),
  xLargeRadius(20),
  extraLargeRadius(24);

  final double value;
  const ProjectRadiusType(this.value);

  BorderRadiusGeometry get allRadius =>
      BorderRadius.all(Radius.circular(value));

  BorderRadiusGeometry get topLeftRadius =>
      BorderRadius.only(topLeft: Radius.circular(value));

  BorderRadiusGeometry get topRightRadius =>
      BorderRadius.only(topRight: Radius.circular(value));

  BorderRadiusGeometry get bottomLeftRadius =>
      BorderRadius.only(bottomLeft: Radius.circular(value));

  BorderRadiusGeometry get bottomRightRadius =>
      BorderRadius.only(bottomRight: Radius.circular(value));

  BorderRadiusGeometry get topLeftRightRadius => BorderRadius.only(
      topLeft: Radius.circular(value), topRight: Radius.circular(value));
}

enum ProjectPaddingType {
  defaultPadding(16.0),
  smallPadding(8.0),
  xSmallPadding(6.0),
  largePadding(24.0),
  extraLargePadding(32.0);

  final double value;
  const ProjectPaddingType(this.value);

  EdgeInsetsGeometry get allPadding => EdgeInsets.all(value);

  EdgeInsetsGeometry get symmetricHorizontalPadding =>
      EdgeInsets.symmetric(horizontal: value);

  EdgeInsetsGeometry get symmetricHorizontalAndHalfVerticalPadding =>
      EdgeInsets.symmetric(horizontal: value,vertical: value/2);

  EdgeInsetsGeometry get symmetricVerticalPadding =>
      EdgeInsets.symmetric(vertical: value);

  EdgeInsetsGeometry get onlyLeftPadding => EdgeInsets.only(left: value);

  EdgeInsetsGeometry get onlyRightPadding => EdgeInsets.only(right: value);

  EdgeInsetsGeometry get onlyTopPadding => EdgeInsets.only(top: value);

  EdgeInsetsGeometry get onlyBottomPadding => EdgeInsets.only(bottom: value);


}
