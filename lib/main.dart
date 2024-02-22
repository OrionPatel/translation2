import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CourseApp());
}

class CourseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CourseScreen(),
    );
  }
}

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> futureCourses;
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  String selectedYear = 'All';
  String selectedDepartment = 'All';
  String query = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCourses = fetchCourses();
    print(futureCourses);
  }

  Future<List<Course>> fetchCourses() async {
    print('fetchcoursescalled');
    final response =
        await http.get(Uri.parse('https://smsapp.bits-postman-lab.in/courses'));

    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Course> courses = [];
      List<dynamic> courseList = data['courses'];
      print(courseList);
      courseList.forEach((courseData) {
        courses.add(Course.fromJson(courseData));
      });
      print(courses.toString());
      setState(() {
        this.courses = courses;
        filteredCourses = courses;
      });
      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void filter() async {
    setState(() {
      if (selectedYear == 'All' && selectedDepartment == 'All') {
        filteredCourses = courses;
      } else {
        filteredCourses = courses.where((course) {
          bool yearCondition =
              selectedYear == 'All' || course.year == selectedYear;
          bool departmentCondition = selectedDepartment == 'All' ||
              course.department == selectedDepartment;
          return yearCondition && departmentCondition;
        }).toList();
      }
    });
  }

  // void filter() {
  //   setState(() {
  //     filteredCourses = courses.where((course) {
  //       bool yearCondition =
  //           selectedYear == 'All' || course.year == selectedYear;
  //       bool departmentCondition = selectedDepartment == 'All' ||
  //           course.department == selectedDepartment;
  //       return yearCondition && departmentCondition;
  //     }).toList();
  //   });
  // }

  // void search(String query) {
  //   setState(() {
  //     this.query = query;
  //     filteredCourses = courses
  //         .where((course) =>
  //             course.courseCode.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  void search(String query) {
    setState(() {
      this.query = query;
      if (query.isEmpty) {
        // If the query is empty, show all courses
        filteredCourses = List.from(courses);
      } else {
        // Filter courses based on courseCode or courseName containing the query
        filteredCourses = courses
            .where((course) =>
                course.courseCode.toLowerCase().contains(query.toLowerCase()) ||
                course.courseName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/1.png'),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color:Color.fromARGB(255, 139, 7, 255) ,),
                child: TextFormField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 139, 7, 255),
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter course code or name',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    search(value);
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 110, 35, 223),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedYear,
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                          print(value);
                          filter();
                          print(filteredCourses);
                        });
                      },
                      items: ['All', '1st', '2nd', '3rd', '4th']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      dropdownColor: const Color.fromARGB(
                          255, 110, 35, 223), // Same color as button
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.white),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      hint: const Text(
                        'Year',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 110, 35, 223),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedDepartment,
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value!;
                          filter();
                        });
                      },
                      items: ['All', 'CS', 'Elec.', 'Mech.']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      dropdownColor: const Color.fromARGB(
                          255, 110, 35, 223), // Same color as button
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.white),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      hint: const Text(
                        'Department',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filteredCourses.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                'assets/rectangular_box_image.png'))),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          filteredCourses[index].courseName,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          filteredCourses[index].courseCode,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Courses {
  List<Course> courses;

  Courses({
    required this.courses,
  });
}

class Course {
  String department;
  String year;
  String courseCode;
  String courseName;

  Course({
    required this.department,
    required this.year,
    required this.courseCode,
    required this.courseName,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      department: json['department'],
      year: json['year'],
      courseCode: json['courseCode'],
      courseName: json['courseName'],
    );
  }
}
