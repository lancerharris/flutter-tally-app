import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        createNavItem(
            context,
            Icon(
              Icons.home,
            )),
        createNavItem(context, Icon(Icons.ac_unit)),
        createNavItem(context, Icon(Icons.supervisor_account)),
        createNavItem(context, Icon(Icons.account_box_rounded)),
        createNavItem(context, Icon(Icons.article)),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}

BottomNavigationBarItem createNavItem(BuildContext context, Icon icon) {
  return BottomNavigationBarItem(
    // backgroundColor: Color.fromRGBO(255, 110, 0, 1),
    icon: icon,
    label: '',
  );
}
