import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:math';
import 'Models/bank_names_model.dart';
import 'api_service.dart';
import 'global_class.dart';

class LoanEligibilityPage extends StatefulWidget {
  final int ficode;

  LoanEligibilityPage({required this.ficode});

  @override
  _LoanEligibilityPageState createState() => _LoanEligibilityPageState();
}

class _LoanEligibilityPageState extends State<LoanEligibilityPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<BankNamesDataModel> bankNamesList = [];
  String? selectedBank;
  double crifScore = 0;
  bool flag = false;

  @override
  void initState() {
    super.initState();
    initializeCrif(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: flag
            ? Column(
          children: <Widget>[
            SizedBox(height: 42),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(
                    child: Image.asset(
                      'assets/Images/logo_white.png', // Replace with your logo asset path
                      height: 40,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomPaint(
                    size: Size(300, 150), // Adjust size if needed
                    painter: SemicircleProgressPainter(crifScore: _animation.value.toInt()),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Loan Eligibility',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    _animation.value.toInt().toString(),
                    style: TextStyle(fontSize: 48.0, color: Colors.white),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (_animation.status == AnimationStatus.completed)
                  Icon(
                    crifScore > 18 && crifScore <= 650 ? Icons.close : Icons.check,
                    color: crifScore > 18 && crifScore <= 650 ? Colors.red : Colors.green,
                    size: 150.0,
                  ),
                if (_animation.status == AnimationStatus.completed)
                  Text(
                    crifScore > 18 && crifScore <= 650 ? 'Sorry!!' : 'Congratulations!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (_animation.status == AnimationStatus.completed)
                  Text(
                    crifScore > 18 && crifScore <= 650
                        ? 'You haven’t met the required criteria!'
                        : 'You meet the required criteria!',
                    style: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            // Try Again Button
            GestureDetector(
              onTap: () {
                GlobalClass.showSuccessAlert(context, "Crif Generated", 3);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Color(0xFFD42D3F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'OKAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
            : null,
      ),
    );
  }

  Future<void> initializeCrif(BuildContext context) async {
    EasyLoading.show(status: "Please wait...");

    final api = ApiService.create(baseUrl: ApiConfig.baseUrl9);

    return await api.generateCrif(/*GlobalClass.creator*/"BAREILLY", "261879").then((value) {
      if (value.statuscode == 200) {
        EasyLoading.dismiss();
        setState(() {
          crifScore = 800;
          flag = true;
          _controller = AnimationController(
            duration: const Duration(seconds: 2),
            vsync: this,
          );

          _animation = Tween<double>(begin: 0, end: crifScore).animate(_controller)
            ..addListener(() {
              setState(() {});
            })
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                // Trigger the icon popup after the needle animation completes
                setState(() {
                  // Here, you could trigger any further logic or animations related to the popup
                });
              }
            });

          _controller.forward();
        });
      } else {
        EasyLoading.dismiss();
        GlobalClass.showUnsuccessfulAlert(context, value.message, 1);
      }
    });
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
    drawScoreRange(canvas, size, Colors.red.withOpacity(0.3), 0.02, 0.34);   // 19-234
    drawScoreRange(canvas, size, Colors.orange.withOpacity(0.3), 0.34, 0.5); // 235-450
    drawScoreRange(canvas, size, Colors.yellow.withOpacity(0.3), 0.5, 0.72); // 451-650
    drawScoreRange(canvas, size, Colors.lightGreen.withOpacity(0.3), 0.72, 0.83); // 651-750
    drawScoreRange(canvas, size, Colors.green.withOpacity(0.3), 0.83, 1.0);  // 751-900



    // Calculate the sweep angle based on the CRIF score
    final double sweepAngle = pi * (crifScore / 900);

    if (crifScore > 0) {
      final Gradient gradient = LinearGradient(
        colors: [Colors.green,Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen,Colors.green],
        stops: [0.0, 0.03,0.26, 0.6, 0.9,1],
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

    drawNeedle(canvas, size, sweepAngle); // Adjust sweepAngle as needed


    // Draw the labels
    final textPainter = (String text, Offset offset, TextStyle style) {
      final TextSpan span = TextSpan(style: style, text: text);
      final TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, offset);
    };


    textPainter('18', Offset(size.width * -0.08, size.height * .87),TextStyle(color: Colors.white));
    textPainter('300', Offset(size.width * 0.18, size.height * -0.02),TextStyle(color: Colors.white));
    textPainter('450', Offset(size.width * 0.45, size.height * -0.15),TextStyle(color: Colors.white));
    textPainter('650', Offset(size.width * 0.82, size.height * .1),TextStyle(color: Colors.white));
    textPainter('750', Offset(size.width * 0.96, size.height * .4),TextStyle(color: Colors.white));
    textPainter('900', Offset(size.width * 0.95, size.height * 1.05),TextStyle(color: Colors.white));
    textPainter(' 0 ', Offset(size.width * -0.04, size.height * 1.05),TextStyle(color: Colors.white));

    textPainter('Very High', Offset(size.width * 0.75, size.height * 0.8), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    textPainter('High', Offset(size.width * 0.78, size.height * 0.39), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    textPainter('Medium', Offset(size.width * 0.55, size.height * 0.25), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    textPainter('Low', Offset(size.width * 0.35, size.height * 0.2), TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
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

  void drawNeedle(Canvas canvas, Size size, double sweepAngle) {
    final double angle = pi + sweepAngle; // Adjust for needle position
    final double needleLength = size.width / 2;
    final double baseWidth = 10;
    final double baseRadius = 10;

    final Paint needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height); // Center of the circle
    final Offset needleTip = Offset(
      center.dx + needleLength * cos(angle),
      center.dy + needleLength * sin(angle),
    );

    // Base center of the needle (keeping the base at the center of the circle)
    final Offset baseCenter = Offset(
      center.dx,
      center.dy,
    );

    final Paint basePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Draw the base circle at the center of the circle
    canvas.drawCircle(baseCenter, baseRadius, basePaint);

    // Needle base (ensuring it is centered and perpendicular to the needle)
    final Offset needleBaseLeft = Offset(
      center.dx - (baseWidth / 2) * cos(angle - pi / 2),
      center.dy - (baseWidth / 2) * sin(angle - pi / 2),
    );

    final Offset needleBaseRight = Offset(
      center.dx + (baseWidth / 2) * cos(angle - pi / 2),
      center.dy + (baseWidth / 2) * sin(angle - pi / 2),
    );

    // Draw the needle path
    final Path needlePath = Path()
      ..moveTo(needleBaseLeft.dx, needleBaseLeft.dy)
      ..lineTo(needleBaseRight.dx, needleBaseRight.dy)
      ..lineTo(needleTip.dx, needleTip.dy)
      ..close();

    canvas.drawPath(needlePath, needlePaint);
  }




}
