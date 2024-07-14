import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int selectedIndexNavBar;

  MyBottomNavigationBar({super.key, required this.selectedIndexNavBar});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  void _onTap(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/bus');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/train');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/taxi');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/game');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Set the height of the navbar
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF3E80CE).withOpacity(0.65),
        items: [
          BottomNavigationBarItem(
            label: 'Bus',
            icon: Icon(
              Icons.directions_bus,
              size: widget.selectedIndexNavBar == 0 ? 35 : 25,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Train',
            icon: Icon(
              Icons.directions_train,
              size: widget.selectedIndexNavBar == 1 ? 35 : 25,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Taxi',
            icon: Icon(
              Icons.directions_car,
              size: widget.selectedIndexNavBar == 2 ? 35 : 25,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Idle',
            icon: Icon(
              Icons.gamepad,
              size: widget.selectedIndexNavBar == 3 ? 35 : 25,
            ),
          ),
        ],
        currentIndex: widget.selectedIndexNavBar,
        onTap: _onTap,
        selectedItemColor: Colors.purple,
      ),
    );
  }
}
