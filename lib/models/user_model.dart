import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = 'number'; //to avoid typo error
  static const ID = 'id';

  String? _number;
  String? _id;

  //getter
  String? get number => _number;
  String? get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    _number = data[NUMBER] as String;
    _id = data[ID] as String;
  }
}
