import 'package:flutter/material.dart';

class HybridBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onCenterPressed;

  const HybridBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onCenterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(Icons.home, "Home", 0),
          buildNavItem(Icons.event, "Events", 1),
          GestureDetector(
            onTap: onCenterPressed,
            child: Container(
              height: 56,
              width: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF8B0000),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          buildNavItem(Icons.photo, "Memories", 3),
          buildNavItem(Icons.group, "Family", 4),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    final bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF8B0000) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF8B0000) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
