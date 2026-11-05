class Student {
  final int? id;
  final String name;
  final String regNo;
  final String email;
  final String phone;
  final String department;
  final String year;

  Student({
    this.id,
    required this.name,
    required this.regNo,
    required this.email,
    required this.phone,
    required this.department,
    required this.year,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'regNo': regNo,
        'email': email,
        'phone': phone,
        'department': department,
        'year': year,
      };

  factory Student.fromMap(Map<String, dynamic> m) => Student(
        id: m['id'] as int?,
        name: m['name'] as String,
        regNo: m['regNo'] as String,
        email: m['email'] as String,
        phone: m['phone'] as String,
        department: m['department'] as String,
        year: m['year'] as String,
      );
}
