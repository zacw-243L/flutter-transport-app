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
  int _points = 0;

  void _moveButton() {
    final random = Random();
    setState(() {
      _top = random.nextDouble() *
              (MediaQuery.of(context).size.height * 0.7 - _size - 50) +
          10; // Leave a 10 pixel margin at the top and bottom
      _left = random.nextDouble() *
              (MediaQuery.of(context).size.width * 1 - _size - 50) +
          10; // Leave a 10 pixel margin at the left and right
      _size = (pow(random.nextDouble(), 2) * 150 + 75).clamp(50.0, 225.0)
          as double; // Skewed random size between 75 and 225
      _color =
          _generateRandomColor(); // Random color excluding white/yellowish hues
      _points = (_size / 10).round(); // Calculate points based on the size
    });
  }

  Color _generateRandomColor() {
    // List of colors to avoid (white/yellowish hues)
    List<Color> avoidColors = [
      Colors.white,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.lightGreen,
      Colors.grey
    ];

    // Generate a random color
    Color color;
    do {
      color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);
    } while (avoidColors.contains(color));

    return color;
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
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 3),
      backgroundColor:
          Colors.grey[200], // Set the background color of the Scaffold
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color of the Container
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
                  onTap: _moveButton,
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
                          offset: Offset(0, 3), // changes position of shadow
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
      ),
    );
  }
}
