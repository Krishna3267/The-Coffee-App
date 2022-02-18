// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field

import 'package:brew_crew/models/firebase_user.dart';
import 'package:brew_crew/models/user_data.dart';
import 'package:brew_crew/services/db.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).user_data,
        //this snapshot is from flutter and it refers to the data coming down
        builder: (context, snapshot) {
          //check that we have data coming down the stream
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Text(
                  'Update your brew Settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  initialValue: userData!.name,
                  decoration: textInputDecor,
                  validator: (val) =>
                      val!.isEmpty ? 'Please Enter a name!' : null,
                  onChanged: (val) {
                    setState(() => _currentName = val);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                //dropdown
                DropdownButtonFormField(
                  value: _currentSugars ?? userData.sugars,
                  items: sugars
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e sugar(s)'),
                          ))
                      .toList(),
                  onChanged: (e) {
                    _currentSugars = e as String?;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //slider
                Slider(
                  min: 100.0,
                  max: 900.0,
                  activeColor:
                      Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor: Colors.brown,
                  divisions: 8,
                  value: (_currentStrength ?? 100).toDouble(),
                  onChanged: (e) {
                    setState(() {
                      _currentStrength = e.round();
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? userData.sugars,
                          _currentName ?? userData.name,
                          _currentStrength ?? userData.strength);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown[900],
                  ),
                )
              ]),
            );
          } else {
            return Loading();
          }
        });
  }
}
