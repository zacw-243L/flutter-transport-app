import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/constants.dart';
import '../utilities/firebase_calls.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double _top = 100;
  double _left = 100;
  double _size = 100;
  Color _color = Colors.blue;
  int _points = 10;
  int _totalPoints = 0; // Initialize total points to zero

  @override
  void initState() {
    super.initState();
    _points = (_size / 10).round(); // Calculate points based on initial size
  }

  void _moveButton() {
    final random = Random();
    setState(() {
      _top = random.nextDouble() *
              (MediaQuery.of(context).size.height * 0.65 - _size - 50) +
          10; // Leave a 10 pixel margin at the top and bottom
      _left = random.nextDouble() *
              (MediaQuery.of(context).size.width * 1 - _size - 50) +
          10; // Leave a 10 pixel margin at the left and right
      _size = (pow(random.nextDouble(), 2) * 150 + 65).clamp(40.0, 225.0)
          as double; // Skewed random size between 75 and 225
      _color =
          _generateRandomColor(); // Random color excluding white/yellowish hues
      _points = (_size / 10).round(); // Calculate points based on the size
      _totalPoints += _points; // Add points to the total points
    });
  }

  Color _generateRandomColor() {
    final random = Random();
    Color color;
    do {
      final hue = random.nextDouble() * 360;
      final saturation = random.nextDouble() * 0.5 + 0.5; // 50% to 100%
      final brightness = random.nextDouble() * 0.5 + 0.5; // 50% to 100%

      color = HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();
    } while (_isBrightOrPastel(color) || _isWhite(color));

    return color;
  }

  bool _isBrightOrPastel(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.lightness > 0.7; // Light colors
  }

  bool _isWhite(Color color) {
    return color == Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5E60CE).withOpacity(0.85),
        title: Text(
          "LionTransport".toUpperCase(),
          style: kAppName,
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor:
          Colors.grey[200], // Set the background color of the Scaffold
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 3),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft, // or Alignment.left
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Total Points: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '$_totalPoints',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color:
                    Colors.white, // Set the background color of the Container
                borderRadius: BorderRadius.circular(0), // Add a rounded corner
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3), // Add a shadow to give depth
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: _top,
                    left: _left,
                    child: GestureDetector(
                      onTap: () {
                        _totalPoints += _points; // Add points on tap
                        _moveButton();
                      },
                      child: Container(
                        width: _size,
                        height: _size,
                        decoration: BoxDecoration(
                          color: _color,
                          borderRadius: BorderRadius.circular(
                              20), // Optional: Adds rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '+$_points',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
