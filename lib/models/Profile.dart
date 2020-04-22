import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String uid;
  final String name;
  final List<String> partners;
  final String photo;

  const Profile({this.uid, this.name, this.partners, this.photo});

  
   Profile.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        name = snapshot['name'],
        photo = snapshot['photo'] ?? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
        partners = [];
}