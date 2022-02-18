import 'package:brew_crew/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  //collection reference

  //if this collection doesnt exist, this command will make one ( in our case on the first run)
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  //ques: what is the link between the firestore document inside a collection and the user, who's doc it is
  //ans: uid

  Future updateUserData(String sugars, String name, int strength) async {
    //here we're passign a map inside the set function
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  List<Brew> _brewListFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
          name: doc.get('name') ?? '',
          strength: doc.get('strength') ?? 0,
          sugars: doc.get('sugars') ?? '0');
    }).toList();
  }

  //stream to get brews streams for outputting lists from all the users
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map((snap) => _brewListFromSnap(snap));
  }

  //stream to get the updates of a PARTICULAR user
  UserData _userDataModelfromDocsnap(DocumentSnapshot snap) {
    return UserData(
        uid: uid!,
        name: snap.get('name'),
        sugars: snap.get('sugars'),
        strength: snap.get('strength'));
  }

  Stream<UserData> get user_data {
    return brewCollection.doc(uid).snapshots().map(_userDataModelfromDocsnap);
  }
}
