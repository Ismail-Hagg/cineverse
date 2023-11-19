import 'dart:io';

import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class FirebaseServices {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference get ref => _ref;

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }

  // add user data to firebase
  Future<void> addUsers(UserModel model) async {
    return await _ref.doc(model.userId).set(model.toMap());
  }

  // update user data
  Future<void> userUpdate(
      {required String userId, required Map<String, dynamic> map}) async {
    _ref.doc(userId).update(map);
  }

  // uploading image to firebase storage
  Future<String> uploadUserImage(
      {required String userId, required String file}) async {
    try {
      UploadTask? uploadTask;
      final String path = '$userId/images/profile';
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(File(file));
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('=====>> $e');
      return '';
    }
  }

  // upload favorites and or watchlist
  Future<void> watchFav(
      {required String userId,
      required FirebaseUserPaths path,
      required MovieDetaleModel model,
      required bool upload}) async {
    upload
        ? await _ref
            .doc(userId)
            .collection(path.name)
            .doc(model.id.toString())
            .set(model.toMap())
        : await _ref
            .doc(userId)
            .collection(path.name)
            .doc(model.id.toString())
            .delete();
  }
}
