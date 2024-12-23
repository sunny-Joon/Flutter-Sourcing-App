import 'package:flutter/material.dart';
import 'dart:math';

class LoanEligibilityPage extends StatefulWidget {
  final int crifScore;

  LoanEligibilityPage({this.crifScore = 900});

  @override
  _LoanEligibilityPageState createState() => _LoanEligibilityPageState();
}

class _LoanEligibilityPageState extends State<LoanEligibilityPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.crifScore.toDouble()).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Eligibility'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 28.0),
                  CustomPaint(
                    size: Size(300, 150), // Adjust size if needed
                    painter: SemicircleProgressPainter(crifScore: _animation.value.toInt()),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Your Score:',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    _animation.value.toInt().toString(),
                    style: TextStyle(fontSize: 48.0),
                  ),
                ],
              ),
            ),
            // Select Bank Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select Bank*'),
                SizedBox(width: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<String>(
                    value: 'SBI',
                    onChanged: (String? newValue) {},
                    items: <String>['SBI', 'HDFC', 'ICICI']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Only 3 attempts to switch bank',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16.0),
            // Error Message
            Column(
              children: [
                Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 50.0,
                ),
                Text(
                  'Sorry!!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'No rules specified for selected bank',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Try Again Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD42D3F),
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              ),
              child: Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}

class SemicircleProgressPainter extends CustomPainter {
  final int crifScore;

  SemicircleProgressPainter({required this.crifScore});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    // Draw the background semicircle
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height * 2),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    // Draw light color shades for score ranges
    drawScoreRange(canvas, size, Colors.green.withOpacity(0.3), 0.0, 0.02); // 0-18
    drawScoreRange(canvas, size, Colors.red.withOpacity(0.3), 0.02, 0.26);   // 19-234
    drawScoreRange(canvas, size, Colors.orange.withOpacity(0.3), 0.26, 0.5); // 235-450
    drawScoreRange(canvas, size, Colors.yellow.withOpacity(0.3), 0.5, 0.72); // 451-650
    drawScoreRange(canvas, size, Colors.lightGreen.withOpacity(0.3), 0.72, 0.83); // 651-750
    drawScoreRange(canvas, size, Colors.green.withOpacity(0.3), 0.83, 1.0);  // 751-900



    // Calculate the sweep angle based on the CRIF score
    final double sweepAngle = pi * (crifScore / 900);

    if (crifScore > 0) {
      final Gradient gradient = LinearGradient(
        colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green],
        stops: [0.0, 0.33, 0.66, 1.0],
      );

      final Rect arcRect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
      final Paint progressPaint = Paint()
        ..shader = gradient.createShader(arcRect)
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Draw the progress semicircle with gradient
      canvas.drawArc(
        arcRect,
        pi,
        sweepAngle,
        false,
        progressPaint,
      );
    }

    // Draw the needle
    final double angle = pi + sweepAngle; // Adjust for needle position
    final double needleLength = size.width / 2;
    final double needleWidth = 5;

    final Paint needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = needleWidth
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height);
    final Offset needleEnd = Offset(
      center.dx + needleLength * cos(angle),
      center.dy + needleLength * sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw the labels
    final textPainter = (String text, Offset offset, TextStyle style) {
      final TextSpan span = TextSpan(style: style, text: text);
      final TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, offset);
    };


    textPainter('150', Offset(size.width * -0.04, size.height * .4),TextStyle(color: Colors.black));
    textPainter('300', Offset(size.width * 0.17, size.height * .0),TextStyle(color: Colors.black));
    textPainter('450', Offset(size.width * 0.45, size.height * -0.15),TextStyle(color: Colors.black));
    textPainter('600', Offset(size.width * 0.77, size.height * .0),TextStyle(color: Colors.black));
    textPainter('750', Offset(size.width * 0.96, size.height * .4),TextStyle(color: Colors.black));
    textPainter('900', Offset(size.width * 0.95, size.height * 1),TextStyle(color: Colors.black));
    textPainter('000', Offset(size.width * -0.04, size.height * 1.05),TextStyle(color: Colors.black));

    textPainter('Very High', Offset(size.width * 0.75, size.height * 0.8), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    textPainter('High', Offset(size.width * 0.78, size.height * 0.39), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    textPainter('Medium', Offset(size.width * 0.55, size.height * 0.25), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    textPainter('Low', Offset(size.width * 0.30, size.height * 0.2), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    textPainter('Very Low', Offset(size.width * 0.05, size.height * 0.7), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));

  }

  void drawScoreRange(Canvas canvas, Size size, Color color, double start, double end) {
    final Paint rangePaint = Paint()
      ..color = color
      ..strokeWidth = 90
      ..style = PaintingStyle.stroke;

    final Rect arcRect = Rect.fromLTWH(50, 50, size.width - 100, size.height * 1.33);

    canvas.drawArc(
      arcRect,
      pi + start * pi,
      (end - start) * pi,
      false,
      rangePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
