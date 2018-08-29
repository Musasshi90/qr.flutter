/*
 * QR.Flutter
 * Copyright (c) 2018 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */
import 'package:flutter/widgets.dart';
import 'package:qr/qr.dart';
import 'dart:ui' as sky;
import 'package:flutter/material.dart';

import 'qr_painter.dart';

class QrImage extends StatelessWidget {
  QrImage({
    this.data,
    this.size,
    this.image,
    this.padding = const EdgeInsets.all(10.0),
    this.backgroundColor,
    this.foregroundColor = const Color(0xFF000000),
    this.version = 4,
    this.errorCorrectionLevel = QrErrorCorrectLevel.L,
    this.onError,
    this.logoSize,
    this.boxFit,
  }) {
    painter = new QrPainter(
        data, foregroundColor, version, this.image, errorCorrectionLevel,
        onError: onError,
        boxFit: this.boxFit,
        logoSize: logoSize);
  }

  QrPainter painter;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double size;
  final QrError onError;
  final sky.Image image;
  final String data;
  final foregroundColor;
  final int errorCorrectionLevel;
  final version;
  final double logoSize;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double widgetSize = size ?? constraints.biggest.shortestSide;
        return new Container(
          width: widgetSize,
          height: widgetSize,
          color: backgroundColor,
          child: new Padding(
            padding: padding,
            child: new CustomPaint(
              painter: painter,
            ),
          ),
        );
      },
    );
  }
}
