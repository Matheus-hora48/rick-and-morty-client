import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      notchMargin: 0,
      color: Colors.white,
      child: Row(
        children: [
          navItem(
            Icons.home_outlined,
            Icons.home_rounded,
            pageIndex == 0,
            onTap: () => onTap(0),
          ),
          navItem(
            Icons.movie_outlined,
            Icons.movie_rounded,
            pageIndex == 1,
            onTap: () => onTap(1),
          ),
          navItem(
            Icons.person_outline,
            Icons.person_rounded,
            pageIndex == 2,
            onTap: () => onTap(2),
          ),
          navItem(
            Icons.history_outlined,
            Icons.history_rounded,
            pageIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }

  Widget navItem(
    IconData icon,
    IconData iconSelected,
    bool selected, {
    Function()? onTap,
  }) {
    const color = Color(0xFF03535c);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          selected ? iconSelected : icon,
          color: selected ? color : color.withOpacity(0.4),
        ),
      ),
    );
  }
}
