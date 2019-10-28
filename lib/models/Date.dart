import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  final String id;
  final String name;
  final String description;
  final String image;
  final String category;
  final List<String> openQuestions;
  final List<String> mcQuestions;

  const Date({this.id, this.name, 
    this.description, this.image, this.category, this.openQuestions, this.mcQuestions});

   Date.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        name = snapshot['name'],
        description = snapshot['description'] ?? '',
        image = snapshot['photo'] ?? '',
        category = snapshot['category'] ?? 'Free Trial',
        openQuestions = List.from(snapshot['open_questions']),
        mcQuestions = List.from(snapshot['mc_questions']);
}


class Category {
  final String id;
  final String name;
  final String description;
  final String image;
  final String longDescription;

  const Category({this.id, this.name, this.description, this.image, this.longDescription});

   Category.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        name = snapshot['name'],
        description = snapshot['description'] ?? '',
        image = snapshot['image'] ?? '',
        longDescription = snapshot['long_description'] ?? '';
}