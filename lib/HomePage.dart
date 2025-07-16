import 'package:flutter/material.dart';

void main() {
  runApp(StudentDashboardApp());
}
 
class StudentDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatelessWidget {
  final Color cardColor = Color(0xFFD9D9D9); // Updated fill color
  final Color backgroundColor = Color(0xFFf7f5ef);

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
            icon: Icon(
              Icons.menu,
              color: Color(0xFFB7BFA4),
              size: 30,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          'blah blah',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Cursive',
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined, color: Colors.black),
          ),
        ],
      ),

      drawer: Drawer(
        child: Center(
          child: Text(
            'Sidebar Menu',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome Xyz!",
                style: TextStyle(fontSize: screenWidth * 0.045)),
            SizedBox(height: screenHeight * 0.015),

            // Expanded Box 1
            Expanded(
              flex: 2,
              child: _buildCard("No Remainders !!", screenWidth),
            ),
            SizedBox(height: screenHeight * 0.015),

            // Expanded Row (Box 2 and 3)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: _buildCard("No notes", screenWidth * 0.45),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreditsPage()),
                          );
                        },
                        child: _buildCard(
                            "Credits Completed\n100/164", screenWidth * 0.45),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // CGPA Circle
            _buildCircularCGPA("8.56"),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Credits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'CGPA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
        ],
      ),
    );
  }

  // Responsive card
  Widget _buildCard(String title, double width) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Circular CGPA widget
  Widget _buildCircularCGPA(String value) {
    double cgpa = double.parse(value);
    return Column(
      children: [
        Container(
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
                  backgroundColor: Color(0xFFf7f5ef),
                  color: Color(0xFFD9D9D9),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text("CGPA",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Color(0xFFB7BFA4),
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Credits Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'This is the Credits Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
