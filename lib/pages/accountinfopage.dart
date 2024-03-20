import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AccountInfoPage extends StatefulWidget {
  final bool isWeb;

  const AccountInfoPage({super.key, required this.isWeb});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  String? email;
  String? user = FirebaseAuth.instance.currentUser?.uid;
  String? firstName;
  String? phone;

  final _userInfo = Hive.box('userData');
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  late final _rePasswordController = TextEditingController();
  late final _reEmailController = TextEditingController();

  bool _editingPassword = false;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    getFname();
    email = FirebaseAuth.instance.currentUser?.email;
  }

  void getFname() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          firstName = documentSnapshot['fname'] as String?;
          phone = documentSnapshot['phone'] as String?;
        });
      } else {
        print('Käyttäjää ei löydy');
      }
    }).catchError((error) {
      print('Virhe: $error');
    });
  }
 

  void _toggleEditing(String condition) {
    if (condition == 'Password') {
      setState(() {
        _editingPassword = !_editingPassword;
      });
    }
  }

  void reAuthenticate() async {
    AuthCredential credential = EmailAuthProvider.credential(
        email: _reEmailController.text, password: _rePasswordController.text);

    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);

    Navigator.of(context).pop();
  }

  void _savePassword(String i) async {
    _toggleEditing('Password');

    try {
      await FirebaseAuth.instance.currentUser!
          .updatePassword(_passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password updated successfully'),
        backgroundColor: Colors.green,
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.add_alert),
            title: const Text('re-authenticate'),
            titleTextStyle: Theme.of(context).textTheme.displayLarge,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _reEmailController,
                  onSaved: (newValue) => _reEmailController.text = newValue!,
                  decoration: const InputDecoration(
                    hintText: ('Email'),
                  ),
                ),
                TextFormField(
                  controller: _rePasswordController,
                  onSaved: (newValue) => _rePasswordController.text = newValue!,
                  decoration: const InputDecoration(
                    hintText: ('Old Password'),
                  ),
                )
              ],
            ),
            actions: [
              TextButton(onPressed: reAuthenticate, child: const Text('Ok')),
            ],
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.red,
      ));
    }

    _userInfo.put('Password', _passwordController.text);
  }

  void _saveAddress(String i) {
    _userInfo.put('Address', i);
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = widget.isWeb ? 400.0 : screenWidth * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Info'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(15),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Container(
                width: fieldWidth,
                color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: [
                        Icon(Icons.account_circle_rounded),
                        Text(
                          'Name:',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$firstName',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.add_ic_call_rounded),
                        Text(
                          'Mobile:',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$phone',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_email_rounded),
                        Text(
                          'Email:',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$email',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    Divider(
                      height: 40,
                      thickness: 1,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.add_home_rounded),
                        Text(
                          'Address:',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _addressController,
                            onFieldSubmitted: (newValue) => _saveAddress(newValue),
                            decoration: InputDecoration(
                              hintText: _userInfo.get('Address'),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.add_moderator_rounded),
                        Text(
                          'Password:',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            onFieldSubmitted: (newValue) => _savePassword(newValue),
                            decoration: InputDecoration(
                              hintText: _userInfo.get('Password'),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            obscureText: _isObscure,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
