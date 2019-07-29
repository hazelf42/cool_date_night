import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  final String id;
  final String name;
  final String description;
  final String image;
  final List<String> openQuestions;
  final List<String> mcQuestions;

  const Date({this.id, this.name, 
    this.description, this.image, this.openQuestions, this.mcQuestions});

   Date.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        name = snapshot['name'],
        description = snapshot['description'] ?? '',
        image = snapshot['photo'] ?? '',
        openQuestions = List.from(snapshot['open_questions']),
        mcQuestions = List.from(snapshot['mc_questions']);
}