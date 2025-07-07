import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String name;
  final String email;

  const AppDrawer({
    super.key,
    required this.name,
    required this.email,
  });
@override
Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.transparent,
    child: Column(
      children: [
        Container(height: 25,color: Colors.transparent,),
       // 🔹 Main Content with Background Color
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 238, 244, 254), // 🟦 Light background
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // 🔷 Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromARGB(255, 238, 244, 254),
                        child: Icon(Icons.person, color: Colors.blue, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$name • Personal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔘 Drawer Items
                _buildDrawerItem('assets/images/image 55.png', 'Getting Started'),
                _buildDrawerItem('assets/images/image 56.png', 'Sync Data'),
                _buildDrawerItem('assets/images/image 57.png', 'Gamification'),
                _buildDrawerItem('assets/images/image 58.png', 'Send Logs'),
                _buildDrawerItem('assets/images/image 59.png', 'Settings'),
                _buildDrawerItem('assets/images/image 60.png', 'Help?'),
                _buildDrawerItem('assets/images/image 61.png', 'Cancel Subscription'),

                const Divider(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(
                    "App Info",
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                _buildDrawerItem('assets/images/image 62.png', 'About Us'),
                _buildDrawerItem('assets/images/image 63.png', 'Privacy Policy'),
                _buildDrawerItem('assets/images/image 64.png', 'Version 1.01.52'),
                _buildDrawerItem('assets/images/image 64(2).png', 'Share App'),
                _buildDrawerItem('assets/images/image 64 (1).png', 'Logout'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildDrawerItem(String imagePath, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: Container(
          height: 40,
          width: 60,
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(
            imagePath,
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          // TODO: Add navigation logic
        },
      ),
    );
  }
}
