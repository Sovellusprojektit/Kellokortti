import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEmployee extends StatefulWidget {
  final bool isWeb;
  
  const AddEmployee({super.key, required this.isWeb});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/abstract_background.png'),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                         Text(
                          'Add Employee',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent[700],
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: const TextStyle(color: Colors.black),
                                controller: _fnameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'First Name',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First Name is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    _fnameController.text = value!,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: TextFormField(
                                style: const TextStyle(color: Colors.black),
                                controller: _lnameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Last Name',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last Name is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    _lnameController.text = value!,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                         TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                            onSaved: (value) => _emailController.text = value!,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                         TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _phoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Phone',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phonenumber is required';
                              }
                              return null;
                            },
                            onSaved: (value) => _phoneController.text = value!,
                            keyboardType: TextInputType.phone,
                          ),
                      
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.orangeAccent[700],
                              minWidth: 150,
                              height: 50,
                              onPressed: () {
                                setState(() {
                                  _isAdmin = !_isAdmin;
                                });
                              },
                              child: _isAdmin
                                  ? const Text('Admin')
                                  : const Text('Employee'),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.orangeAccent[700],
                              minWidth: 150,
                              height: 50,
                              onPressed: () {
                                addEmployee();
                                Navigator.pop(context);
                              },
                              child: const Text('Add Employee'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addEmployee() async {
    try {
      if (_formKey.currentState!.validate()) {
          await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _lnameController.text + _phoneController.text)    
            .then((value) => {
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(value.user!.uid)
                      .set({
                    'fname': _fnameController.text,
                    'lname': _lnameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'isAdmin': _isAdmin,
                    'isWorking': false,
                  })
                });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The email is invalid.')));
      } else {
        print(e.code);
      }
    }
  }
}
