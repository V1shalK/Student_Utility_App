import 'package:flutter/material.dart';
import 'HomePage.dart'; // Import DashboardPage to navigate back

class CGPAHomePage extends StatefulWidget {
  const CGPAHomePage({super.key});

  @override
  State<CGPAHomePage> createState() => _CGPAHomePageState();
}

class _CGPAHomePageState extends State<CGPAHomePage> {
  double gpa = 0.0;
  String selectedDept = '';
  String selectedSem = '';
  Map<String, List<Map<String, dynamic>>> allSubjectsPerSem = {};

  Map<String, List<Map<String, dynamic>>> deptSubjects = {
    'CSE': [
      {'name': 'Data Structures', 'credits': 3},
      {'name': 'OOP', 'credits': 4},
      {'name': 'Mobile Robotics ', 'credits': 3},
      {'name': 'Robotic Sensors', 'credits': 3},
      {'name': 'Soft Computing ', 'credits': 3},
      {'name': 'Modern Web Application Developmen', 'credits': 4},
      {'name': 'Bigdata Analytics ', 'credits': 2},
    ],
    'ECE': [
      {'name': 'Digital Circuits', 'credits': 3},
      {'name': 'Analog Devices', 'credits': 4},
    ],
    'MECH': [
      {'name': 'Thermodynamics', 'credits': 3},
      {'name': 'Mechanics', 'credits': 3},
    ],
  };

  Map<String, int> gradeMap = {
    'A+': 10,
    'A': 9,
    'B+': 8,
    'B': 7,
    'C': 6,
    'F': 0,
    'U': 0,
    'O': 10,
  };

  List<Map<String, dynamic>> get subjects =>
      allSubjectsPerSem[selectedSem] ?? [];

  // Updated: Get all subjects used across any semester
  List<String> getUsedSubjects() {
    final used = <String>{};
    allSubjectsPerSem.forEach((sem, subs) {
      for (var sub in subs) {
        used.add(sub['name']);
      }
    });
    return used.toList();
  }

  // Filter available subjects based on what's already used across all semesters
  List<Map<String, dynamic>> getAvailableSubjects() {
    final baseList = deptSubjects[selectedDept] ?? [];
    final used = getUsedSubjects();
    return baseList.where((subj) => !used.contains(subj['name'])).toList();
  }

  double calculateGPA(List<Map<String, dynamic>> subs) {
    double totalPoints = 0;
    int totalCredits = 0;
    for (var sub in subs) {
      if (sub['grade'] != null) {
        final gradeValue = gradeMap[sub['grade']]!;
        // Ensure credits are treated as int
        final credits = (sub['credits'] as int);
        totalPoints += gradeValue * credits;
        totalCredits += credits;
      }
    }
    if (totalCredits == 0) return 0.0;
    return totalPoints / totalCredits;
  }

  // Corrected: Calculate overall CGPA across all semesters
  double calculateCGPA() {
    double totalPoints = 0;
    int totalCredits = 0;
    allSubjectsPerSem.forEach((_, subs) {
      for (var sub in subs) {
        if (sub['grade'] != null && sub['grade'] != 'U') {
          final gradeValue = gradeMap[sub['grade']]!;
          // Ensure credits are treated as int
          final credits = (sub['credits'] as int);
          totalPoints += gradeValue * credits;
          totalCredits += credits;
        }
      }
    });
    if (totalCredits == 0) return 0.0;
    return totalPoints / totalCredits;
  }

  // This getter now correctly calculates total credits for the CURRENTLY SELECTED semester
  int get currentSemesterTotalCredits {
    return subjects.fold(0, (sum, sub) => sum + (sub['credits'] as int));
  }

  // This getter now correctly calculates total credits for ALL semesters combined
  int get overallTotalCredits {
    int total = 0;
    allSubjectsPerSem.forEach((sem, subs) {
      total += subs.fold(0, (sum, sub) => sum + (sub['credits'] as int));
    });
    return total;
  }

  int get enrolledCredits {
    // This correctly refers to the enrolled credits for the SELECTED semester
    return subjects
        .where((s) => s['grade'] != null)
        .fold(0, (sum, s) => sum + (s['credits'] as int));
  }

  void showAddCoursePopup() {
    if (selectedDept.isEmpty || selectedSem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Department and Semester')),
      );
      return;
    }
    List<Map<String, dynamic>> availableSubjects = getAvailableSubjects();

    if (availableSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No new subjects available for this department.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Subject'),
          children: availableSubjects.map((subj) {
            return ListTile(
              title: Text('${subj['name']} (${subj['credits']} Cr)'),
              onTap: () {
                setState(() {
                  final updatedList = [
                    ...subjects,
                    {
                      'name': subj['name'],
                      'credits': subj['credits'],
                      'grade': null, // Changed default grade to null
                    }
                  ];
                  allSubjectsPerSem[selectedSem] = updatedList;
                  gpa = calculateGPA(updatedList);
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  Widget buildTopBarWithHome() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: goToDashboard,
            child: const Icon(Icons.home, size: 28),
          ),
          const Text(
            'CGPA Tracker',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget buildCGPAPill() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CGPA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB7BFA4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                calculateCGPA().toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDropdown(
            'Dept',
            selectedDept,
            (val) {
              setState(() {
                selectedDept = val!;
                selectedSem = '';
                gpa = 0.0;
              });
            },
            deptSubjects.keys.toList(),
            key: ValueKey('dept_$selectedDept'),
          ),
          buildDropdown(
            'Sem',
            selectedSem,
            (val) {
              setState(() {
                selectedSem = val!;
                gpa = calculateGPA(allSubjectsPerSem[selectedSem] ?? []);
              });
            },
            List.generate(8, (i) => (i + 1).toString()),
            prefix: 'Sem ',
            key: ValueKey('sem_$selectedSem'),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(
    String hint,
    String value,
    Function(String?) onChanged,
    List<String> items, {
    String prefix = '',
    Key? key,
  }) {
    return Container(
      key: key,
      width: 120,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB7BFA4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isNotEmpty ? value : null,
          onChanged: onChanged,
          hint: Text(
            hint,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                '$prefix$val',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          dropdownColor: const Color(0xFFFAF9F6),
          isExpanded: true,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget buildAddCourse({Alignment alignment = Alignment.center, Offset offset = Offset.zero}) {
    final bool canAddCourse = selectedDept.isNotEmpty && selectedSem.isNotEmpty;

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: const Offset(-10, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                  color: canAddCourse ? const Color(0xFFE4E0DA) : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: canAddCourse ? const Color(0xFFD3CEC7) : Colors.grey.shade400, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add a new Course',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    color: canAddCourse ? Colors.black : Colors.grey.shade600,
                  ),
                ),
              ),
              Positioned(
                right: -22.5,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: canAddCourse ? showAddCoursePopup : null,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: canAddCourse ? const Color(0xFFB7BFA4) : Colors.grey.shade500,
                      shape: BoxShape.circle,
                      border: Border.all(color: canAddCourse ? const Color(0xFFD3CEC7) : Colors.grey.shade400, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.add, color: canAddCourse ? Colors.white : Colors.white70, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubjectRow(Map<String, dynamic> subject) {
    String displayGrade = subject['grade'] ?? '-';

    return Dismissible(
      key: Key(subject['name']),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() {
          allSubjectsPerSem[selectedSem] = [...subjects]..remove(subject);
          gpa = calculateGPA(allSubjectsPerSem[selectedSem] ?? []);
        });
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width - 50,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4E0DA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(left: 60, right: 40),
                  alignment: Alignment.center,
                  child: Text(
                    subject['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD3CEC7), width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (subject['credits'] as int).toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -22.5,
                top: 0,
                child: GestureDetector(
                  onTap: () => showGradeDialog(subject),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCCCCC),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD3CEC7), width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      displayGrade,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showGradeDialog(Map<String, dynamic> subject) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Grade'),
          children: gradeMap.keys.map((grade) {
            return ListTile(
              title: Text(grade),
              onTap: () {
                setState(() {
                  subject['grade'] = grade;
                  gpa = calculateGPA(allSubjectsPerSem[selectedSem] ?? []);
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildBottomSummary() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 32),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$enrolledCredits', // Credits Enrolled for current semester
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Credits Enrolled',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$overallTotalCredits', // Total Credits for all semesters
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Total Credits',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 0),
            child: Column(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFA6C48A),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        calculateGPA(allSubjectsPerSem[selectedSem] ?? []).toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'GPA',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildTopBarWithHome(),
            buildCGPAPill(),
            buildDropdownsRow(),
            buildAddCourse(),
            Expanded(
              child: selectedDept.isEmpty || selectedSem.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Please select a Department and Semester to view or add subjects.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  : subjects.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No subjects added for this semester.\nTap "+" to add courses.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          itemCount: subjects.length,
                          itemBuilder: (context, index) {
                            return buildSubjectRow(subjects[index]);
                          },
                        ),
            ),
            buildBottomSummary(),
          ],
        ),
      ),
    );
  }
}