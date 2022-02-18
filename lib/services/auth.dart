import 'package:brew_crew/models/firebase_user.dart';
import 'package:brew_crew/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //final property means its not gonna change in future
  //type = FirebaseAuth from firebase
  //property = auth
  //underscore at the beg means that this property is private and can be used in this file only not oth files

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //our own FirebaseUser class from firebase_user.dart
  FirebaseUser? _userFromUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  //auth status change stream
//user is from firebase
  Stream<FirebaseUser?> get stat {
    return _auth.authStateChanges().map(_userFromUser);
    // .map((User? user) => _userFromUser(user));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      //this will return an auth result in form of an kinda object or so
      //UserCredential,User? are firebase objects
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromUser(user);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  //sing in with email and pass
  Future signIn(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future signUp(String email, String pass) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User? user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user?.uid).updateUserData('0', 'Krishna', 100);

      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      //this signOut right down is from firebase
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
