/*
 * QR.Flutter
 * Copyright (c) 2018 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */
import 'package:flutter/widgets.dart';
import 'package:qr/qr.dart';
import 'dart:ui' as sky;

typedef void QrError(dynamic error);

class QrPainter extends CustomPainter {
  QrPainter(String data, this.color, this.version, this.image,
      this.errorCorrectionLevel,
      {this.onError, this.logoSize, this.boxFit})
      : this._qr = new QrCode(version, errorCorrectionLevel) {
    _p.color = this.color;
    // configure and make the QR code data
    try {
      _qr.addData(data);
      _qr.make();
    } catch (ex) {
      if (this.onError != null) {
        _hasError = true;
        this.onError(ex);
      }
    }
  }

  final QrCode _qr; // our qr code data
  final _p = new Paint()..style = PaintingStyle.fill;
  bool _hasError = false;

  // properties
  final int version; // the qr code version
  final int errorCorrectionLevel; // the qr code error correction level
  final Color color; // the color of the dark squares
  final QrError onError;
  final double logoSize;
  final BoxFit boxFit;
  sky.Image image;
  bool isRestore = false;

  @override
  void paint(Canvas canvas, Size size) {
    if (_hasError) return;
    if (size.shortestSide == 0) {
      print(
          "[QR] WARN: width or height is zero. You should set a 'size' value or nest this painter in a Widget that defines a non-zero size");
    }
    final squareSize = size.shortestSide / _qr.moduleCount;
    for (int x = 0; x < _qr.moduleCount; x++) {
      for (int y = 0; y < _qr.moduleCount; y++) {
        if (_qr.isDark(y, x)) {
          final squareRect = new Rect.fromLTWH(
              x * squareSize, y * squareSize, squareSize, squareSize);
          canvas.drawRect(squareRect, _p);
        }
      }
    }

    if (image != null) {
      double widthOfImage = size.width / 3;
      double heightOfImage = size.height / 3;

      final Rect rect = Offset.zero & size;
      //resize the image
      Size resizedImageSize = new Size(
          logoSize == null ? widthOfImage : logoSize,
          logoSize == null ? heightOfImage : logoSize);
      final Size originalImageSize =
          new Size(image.width.toDouble(), image.height.toDouble());
      FittedSizes sizes = applyBoxFit(
          this.boxFit == null ? BoxFit.contain : this.boxFit,
          originalImageSize,
          resizedImageSize);
      // if you don't want it centered for some reason change this.
      final Rect inputSubrect = Alignment.center
          .inscribe(sizes.source, Offset.zero & originalImageSize);
      final Rect outputSubrect =
          Alignment.center.inscribe(sizes.destination, rect);
      canvas.drawImageRect(image, inputSubrect, outputSubrect, new Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is QrPainter) {
      return this.color != oldDelegate.color ||
          this.errorCorrectionLevel != oldDelegate.errorCorrectionLevel ||
          this.version != oldDelegate.version ||
          this._qr != oldDelegate._qr ||
          this.image != oldDelegate.image;
    }
    return false;
  }
}
