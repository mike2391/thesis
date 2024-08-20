import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavbarElement extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavbarElement({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: BottomAppBar(
        height: 63,
        color: const Color(0xff315EFF), // Blue color
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Space around the items
          children: [
            navItem(
              icon: Icons.home_outlined,
              label: 'Home',
              selected: pageIndex == 0,
              onTap: () => onTap(0),
            ),
            navItem(
              icon: Icons.calendar_month_outlined,
              label: 'Calendar',
              selected: pageIndex == 1,
              onTap: () => onTap(1),
            ),
            navItem(
              icon: CupertinoIcons.book_solid,
              label: 'Learning',
              selected: pageIndex == 2,
              onTap: () => onTap(2),
            ),
            navItem(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: pageIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem({required IconData icon, required String label, required bool selected, Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white.withOpacity(0.4),
              size: 25.0, // Adjust icon size as needed
            ),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white.withOpacity(0.4),
                fontSize: 10.0, // Adjust font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
