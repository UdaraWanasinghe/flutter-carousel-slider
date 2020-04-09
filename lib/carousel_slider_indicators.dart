import 'package:flutter/material.dart';

class CircularSlideIndicator implements SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;

  CircularSlideIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: CircularIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
          ),
        ),
      ),
    );
  }
}

class CircularIndicatorPainter extends CustomPainter {
  final int itemCount;
  final double radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();
  final int currentPage;
  final double pageDelta;

  CircularIndicatorPainter({
    @required this.currentPage,
    @required this.pageDelta,
    @required this.itemCount,
    this.radius = 12,
    Color currentIndicatorColor,
    Color indicatorBackgroundColor,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dx = ((size.width - 2 * radius) / (itemCount - 1));
    final y = size.height / 2;
    double x = radius;
    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(x, y), radius, indicatorPaint);
      x += dx;
    }
    canvas.save();
    double midX = radius + dx * currentPage;
    double midY = size.height / 2;
    final path = Path();
    path.addOval(Rect.fromLTRB(
        midX - radius, midY - radius, midX + radius, midY + radius));
    if (currentPage == itemCount - 1) {
      path.addOval(Rect.fromLTRB(0, midY - radius, 2 * radius, midY + radius));
      canvas.clipPath(path);
      canvas.drawCircle(Offset(2 * radius * pageDelta - radius, midY), radius,
          currentIndicatorPaint);
      midX += 2 * radius * pageDelta;
    } else {
      midX += dx;
      path.addOval(Rect.fromLTRB(
          midX - radius, midY - radius, midX + radius, midY + radius));
      midX -= dx;
      canvas.clipPath(path);
      midX += dx * pageDelta;
    }
    canvas.drawCircle(Offset(midX, midY), radius, currentIndicatorPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularWaveSlideIndicator implements SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;

  CircularWaveSlideIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: CircularWaveIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
          ),
        ),
      ),
    );
  }
}

class CircularWaveIndicatorPainter extends CustomPainter {
  final int itemCount;
  final int currentPage;
  final double pageDelta;
  final double radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();

  CircularWaveIndicatorPainter({
    this.itemCount,
    this.currentPage,
    this.pageDelta,
    this.radius,
    Color currentIndicatorColor,
    Color indicatorBackgroundColor,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dx = ((size.width - 2 * radius) / (itemCount - 1));
    final y = size.height / 2;
    double x = radius;
    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(x, y), radius, indicatorPaint);
      x += dx;
    }
    double midX = radius + dx * currentPage;
    double midY = size.height / 2;
    double r = radius * ((1.4 * pageDelta - 0.7).abs() + 0.3);
    if (currentPage == itemCount - 1) {
      canvas.save();
      final path = Path();
      path.addOval(Rect.fromLTRB(0, midY - radius, 2 * radius, midY + radius));
      path.addOval(Rect.fromLTRB(
          size.width - 2 * radius, midY - radius, size.width, midY + radius));
      canvas.clipPath(path);
      canvas.drawCircle(Offset(2 * radius * pageDelta - radius, midY), r,
          currentIndicatorPaint);
      midX += 2 * radius * pageDelta;
    } else {
      midX += dx * pageDelta;
    }
    canvas.drawCircle(Offset(midX, midY), r, currentIndicatorPaint);
    if (currentPage == itemCount - 1) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularStaticIndicator extends SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;
  final bool enableAnimation;

  CircularStaticIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
    this.enableAnimation = false,
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: CircularStaticIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
            enableAnimation: enableAnimation,
          ),
        ),
      ),
    );
  }
}

class CircularStaticIndicatorPainter extends CustomPainter {
  final int itemCount;
  final double radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();
  final int currentPage;
  final double pageDelta;
  final bool enableAnimation;

  CircularStaticIndicatorPainter({
    @required this.currentPage,
    @required this.pageDelta,
    @required this.itemCount,
    this.radius = 12,
    Color currentIndicatorColor,
    Color indicatorBackgroundColor,
    this.enableAnimation = false,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dx = ((size.width - 2 * radius) / (itemCount - 1));
    final y = size.height / 2;
    double x = radius;
    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(x, y), radius, indicatorPaint);
      if (i == currentPage) {
        canvas.drawCircle(
            Offset(x, y),
            enableAnimation ? radius - radius * pageDelta : radius,
            currentIndicatorPaint);
      }
      if (enableAnimation &&
          (i == currentPage + 1 || currentPage == itemCount - 1 && i == 0)) {
        canvas.drawCircle(
            Offset(x, y),
            enableAnimation ? radius * pageDelta : radius,
            currentIndicatorPaint);
      }
      x += dx;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SequentialFillIndicator extends SlideIndicator {
  final double itemSpacing;
  final double indicatorRadius;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final Color currentIndicatorColor;
  final Color indicatorBackgroundColor;
  final bool enableAnimation;

  SequentialFillIndicator({
    this.itemSpacing = 20,
    this.indicatorRadius = 6,
    this.padding,
    this.alignment = Alignment.bottomCenter,
    this.currentIndicatorColor = const Color(0xFF000000),
    this.indicatorBackgroundColor = const Color(0x64000000),
    this.enableAnimation = false,
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    return Container(
      alignment: alignment,
      padding: padding,
      child: SizedBox(
        width: itemCount * itemSpacing,
        height: indicatorRadius * 2,
        child: CustomPaint(
          painter: SequentialFillIndicatorPainter(
            currentIndicatorColor: currentIndicatorColor,
            indicatorBackgroundColor: indicatorBackgroundColor,
            currentPage: currentPage,
            pageDelta: pageDelta,
            itemCount: itemCount,
            radius: indicatorRadius,
            enableAnimation: enableAnimation,
          ),
        ),
      ),
    );
  }
}

class SequentialFillIndicatorPainter extends CustomPainter {
  final int itemCount;
  final double radius;
  final Paint indicatorPaint = Paint();
  final Paint currentIndicatorPaint = Paint();
  final int currentPage;
  final double pageDelta;
  final bool enableAnimation;

  SequentialFillIndicatorPainter({
    @required this.currentPage,
    @required this.pageDelta,
    @required this.itemCount,
    this.radius = 12,
    Color currentIndicatorColor,
    Color indicatorBackgroundColor,
    this.enableAnimation = false,
  }) {
    indicatorPaint.color = indicatorBackgroundColor;
    indicatorPaint.style = PaintingStyle.fill;
    indicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.color = currentIndicatorColor;
    currentIndicatorPaint.style = PaintingStyle.fill;
    currentIndicatorPaint.isAntiAlias = true;
    currentIndicatorPaint.strokeCap = StrokeCap.round;
    currentIndicatorPaint.strokeWidth = radius * 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int currentPage = this.currentPage;
    if (this.currentPage + pageDelta > itemCount - 1) {
      currentPage = 0;
    }
    final dx = ((size.width - 2 * radius) / (itemCount - 1));
    final y = size.height / 2;
    double x = radius;
    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(x, y), radius, indicatorPaint);
      x += dx;
    }
    canvas.save();
    x = radius;
    final path = Path();
    for (int i = 0; i < itemCount; i++) {
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
      x += dx;
    }
    canvas.clipPath(path);
    x = radius;
    if (this.currentPage + pageDelta > itemCount - 1) {
      canvas.drawLine(
          Offset(-radius, y),
          Offset(dx * currentPage + radius * 2 * pageDelta - radius, y),
          currentIndicatorPaint);
    } else {
      canvas.drawLine(
          Offset(-radius, y),
          Offset(dx * currentPage + dx * pageDelta + radius, y),
          currentIndicatorPaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

abstract class SlideIndicator {
  Widget build(int currentPage, double pageDelta, int itemCount);
}
