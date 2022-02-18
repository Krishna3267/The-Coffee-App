// ignore_for_file: prefer_const_constructors

import 'package:brew_crew/models/firebase_user.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //accessing the user data from the provider
    final stat = Provider.of<FirebaseUser?>(context);

    //Return either Home or authenticate widget

    if (stat == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
