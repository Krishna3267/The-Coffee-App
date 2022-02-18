// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  //text field state
  String email = '';

  //pass field state
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Sign up to Brew Crew'),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    widget
                        .toggleView(); //widget refers to the register widget itself
                  },
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  style: TextButton.styleFrom(
                    primary: Colors.brown[900],
                    padding: const EdgeInsets.all(16.0),
                  ),
                )
              ],
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  //this key will keep track of our form state
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email!' : null,
                          style: TextStyle(
                            color: Colors.brown[900],
                          ),
                          cursorColor: Colors.brown[900],
                          decoration:
                              textInputDecor.copyWith(hintText: 'Email'),
                          //this func is gonna run everytime the value changes
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.brown[900],
                          ),
                          cursorColor: Colors.brown[900],
                          decoration:
                              textInputDecor.copyWith(hintText: 'Password'),
                          //this func is gonna run everytime the value changes
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          }),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.signUp(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please enter a valid email.';
                              });
                            }
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown[900],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )),
          );
  }
}
