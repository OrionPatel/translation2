
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
}

