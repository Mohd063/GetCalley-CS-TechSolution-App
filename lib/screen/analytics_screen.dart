import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_calley/provider/list_provider.dart';
import 'package:get_calley/widgets/appdrawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final String userId = '68626fb697757cb741f449b9';
  String selectedStatus = '';
  String name = '';
  String email = '';

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'User';
      email = prefs.getString('email') ?? 'user@example.com';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    Future.delayed(Duration.zero, () {
      Provider.of<ListProvider>(context, listen: false).fetchCallList(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final isLoading = listProvider.isLoading;
    final callList = listProvider.callList;

    final total = callList.length;
    final done = callList.where((e) => (e['status'] ?? '').toString().toLowerCase() == 'done' || (e['status'] ?? '').toString().toLowerCase() == 'called').length;
    final pending = callList.where((e) => (e['status'] ?? '').toString().toLowerCase() == 'pending').length;
    final rescheduled = callList.where((e) => e['rescheduledAt'] != null && e['rescheduledAt'].toString().isNotEmpty).length;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(name: name, email: email),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/image 21.png', width: 23, height: 23),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset('assets/images/image 22.png', width: 26, height: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Test List",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "$total",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const Text(
                              "CALLS",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (selectedStatus.isNotEmpty)
                    Text(
                      _getSelectedDetail(selectedStatus, pending, done, rescheduled),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        startDegreeOffset: -90,
                        sections: _buildPieSections(selectedStatus, pending, done, rescheduled),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = selectedStatus == 'Pending' ? '' : 'Pending';
                            });
                          },
                          child: _buildStatCard("Pending", pending, const Color(0xFFFFC107), const Color(0xFFFFF8E1)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = selectedStatus == 'Done' ? '' : 'Done';
                            });
                          },
                          child: _buildStatCard("Done", done, const Color(0xFF81C784), const Color(0xFFE8F5E9)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = selectedStatus == 'Schedule' ? '' : 'Schedule';
                            });
                          },
                          child: _buildStatCard("Schedule", rescheduled, const Color(0xFFBA68C8), const Color(0xFFF3E5F5)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Start Calling Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, int value, Color lineColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 32,
            decoration: BoxDecoration(
              color: lineColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$value Calls",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(String selectedStatus, int pending, int done, int rescheduled) {
    return [
      PieChartSectionData(
        color: const Color(0xFFFFC107),
        value: pending.toDouble(),
        radius: selectedStatus == 'Pending' ? 60 : 50,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF81C784),
        value: done.toDouble(),
        radius: selectedStatus == 'Done' ? 60 : 50,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFFBA68C8),
        value: rescheduled.toDouble(),
        radius: selectedStatus == 'Schedule' ? 60 : 50,
        showTitle: false,
      ),
    ];
  }

  String _getSelectedDetail(String status, int pending, int done, int rescheduled) {
    switch (status) {
      case 'Pending':
        return "Pending Calls: $pending";
      case 'Done':
        return "Done Calls: $done";
      case 'Schedule':
        return "Scheduled Calls: $rescheduled";
      default:
        return '';
    }
  }
}
