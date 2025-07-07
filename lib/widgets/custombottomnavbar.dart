import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF7FF),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF2563EB),
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 🏠 Home Image Icon
          IconButton(
            icon: Image.asset(
              'assets/images/image 65.png',
              color: currentIndex == 0 ? const Color(0xFF2563EB) : Colors.black,
              height: 26,
              width: 26,
            ),
            onPressed: () => onTap(0),
          ),

          // 📄 Article Image Icon
          IconButton(
            icon: Image.asset(
              'assets/images/image 66.png',
              color: currentIndex == 1 ? const Color(0xFF2563EB) : Colors.black,
              height: 26,
              width: 26,
            ),
            onPressed: () => onTap(1),
          ),

          // 🔵 Center Play Button same as before
          GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(30),  
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
               
              ),
              child: Image.asset(
              'assets/images/image 80.png',
              color: currentIndex == 3 ? const Color(0xFF2563EB) : Colors.white,
              height: 26,
              width: 26,
            ),
            ),
          ),

          // 📞 Call Image Icon
          IconButton(
            icon: Image.asset(
              'assets/images/image 68.png',
              color: currentIndex == 3 ? const Color(0xFF2563EB) : Colors.black,
              height: 26,
              width: 26,
            ),
            onPressed: () => onTap(3),
          ),

          // 👤 Calendar Image Icon
          IconButton(
            icon: Image.asset(
              'assets/images/image 69.png',
              color: currentIndex == 4 ? const Color(0xFF2563EB) : Colors.black,
              height: 26,
              width: 26,
            ),
            onPressed: () => onTap(4),
          ),
        ],
      ),
    );
  }
}
