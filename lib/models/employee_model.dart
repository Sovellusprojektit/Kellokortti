

class Employee {
  final String id;
  final String fname;
  final String lname;
  final String? email;
  final String? phone;
  final bool? isWorking;
  final bool? isManager; 

  Employee({
    required this.id,
    required this.fname,
    required this.lname,
    this.email,
    this.phone,
    this.isWorking,
    this.isManager,
  });
} 

