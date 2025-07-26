import 'package:flutter/material.dart';
import 'CGPA.dart'; // Import the actual CGPA page
// If CreditsPage is to be a separate file, create lib/credits_page.dart and import it:
// import 'package:cgpa_tracker_app/credits_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Color cardColor = const Color(0xFFD9D9D9);
  final Color backgroundColor = const Color(0xFFf7f5ef);

  int _selectedIndex = 0; // This state is only for visual indication of selected tab

  void _onItemTapped(int index) {
    if (index == 1) { // Assuming CGPA is at index 1 in your BottomNavigationBar
      // Navigate to CGPAHomePage
      // Using push instead of pushReplacement so you can go back to dashboard
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CGPAHomePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index; // Update selected index for other tabs if they don't navigate away
      });
      // Handle other navigation items here if they lead to different pages
      // For example:
      // if (index == 0) {
      //   // Navigate to Credits summary page (if distinct from current credits card)
      // }
      // if (index == 2) {
      //   // Navigate to Attendance page
      // }
      // if (index == 3) {
      //   // Navigate to Notes page
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFB7BFA4), size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('blah blah', style: TextStyle(fontFamily: 'Cursive', fontSize: 22)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined, color: Colors.black),
          )
        ],
      ),
      drawer: const Drawer(
        child: Center(child: Text('Sidebar Menu', style: TextStyle(fontSize: 18))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome Xyz!", style: TextStyle(fontSize: screenWidth * 0.045)),
            SizedBox(height: screenHeight * 0.015),
            Expanded(flex: 2, child: _buildCard("No Remainders !!", screenWidth)),
            SizedBox(height: screenHeight * 0.015),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: _buildCard("No notes", screenWidth * 0.45)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        // Navigate to CreditsPage
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreditsPage())),
                        child: _buildCard("Credits Completed\n100/164", screenWidth * 0.45),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildCircularCGPA("8.56"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Credits'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'CGPA'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
        ],
      ),
    );
  }

  Widget _buildCard(String title, double width) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCircularCGPA(String value) {
    double cgpa = double.parse(value);
    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: cgpa / 10,
                  strokeWidth: 20,
                  backgroundColor: const Color(0xFFf7f5ef),
                  color: const Color(0xFFD9D9D9),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text("CGPA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

// CreditsPage - Keeping it here for now, but ideally it would be in lib/credits_page.dart
class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Color(0xFFB7BFA4), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Credits Page', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: const Center(child: Text('This is the Credits Page', style: TextStyle(fontSize: 20))),
    );
  }
}