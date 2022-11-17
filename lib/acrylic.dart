import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AcrylicPainter extends CustomPainter {
  static Image noise = Image.asset('assets/noise.png');
  Color tint;
  double tintOpacity;
  ui.Image? noiseTexture;

  AcrylicPainter({
    required this.tint,
    required this.tintOpacity,
    this.noiseTexture,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..blendMode = BlendMode.colorDodge
        ..style = PaintingStyle.fill,
    );

    canvas.saveLayer(
      Offset.zero & size,
      Paint()..color = Colors.white,
    );

    canvas.drawRect(
      Offset.zero & size,
      Paint()..blendMode = BlendMode.clear,
    );

    if (noiseTexture != null) {
      paintImage(
        canvas: canvas,
        rect: Offset.zero & size,
        image: noiseTexture!,
        repeat: ImageRepeat.repeat,
        scale: 2,
      );
      canvas.saveLayer(
        Offset.zero & size,
        Paint()
          ..blendMode = BlendMode.multiply
          ..color = Colors.white,
      );
    }

    if (noiseTexture != null) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..blendMode = BlendMode.clear,
      );
    }

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = tint.withOpacity(tintOpacity)
        ..style = PaintingStyle.fill,
    );

    if (noiseTexture != null) {
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(AcrylicPainter oldDelegate) {
    return oldDelegate.tint != tint ||
        oldDelegate.tintOpacity != tintOpacity ||
        oldDelegate.noiseTexture != noiseTexture;
  }

  @override
  bool shouldRebuildSemantics(AcrylicPainter oldDelegate) {
    return oldDelegate.tint != tint ||
        oldDelegate.tintOpacity != tintOpacity ||
        oldDelegate.noiseTexture != noiseTexture;
  }
}

class Acrylic extends StatelessWidget {
  static final Future<ui.Image> _noiseFuture =
      Acrylic.loadImage('assets/noise2.png');

  static Future<ui.Image> loadImage(String path) async {
    final data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  Widget? child;
  Color tint;
  double tintOpacity;
  Acrylic({
    Key? key,
    this.child,
    this.tint = Colors.grey,
    this.tintOpacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _noiseFuture,
      builder: (context, snapshot) {
        return ClipRect(
          child: CustomPaint(
            foregroundPainter: AcrylicPainter(
              tint: tint,
              tintOpacity: tintOpacity,
              noiseTexture: snapshot.data as ui.Image?,
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
