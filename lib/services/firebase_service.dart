import 'dart:io';

import 'package:cineverse/models/comment_model.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class FirebaseServices {
  final CollectionReference _ref = FirebaseFirestore.instance.collection(
      '${FirebaseMainPaths.users.name[0].toUpperCase()}${FirebaseMainPaths.users.name.substring(1)}');

  final CollectionReference _refOther =
      FirebaseFirestore.instance.collection(FirebaseMainPaths.other.name);

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
      return '';
    }
  }

  // upload favorites and or watchlist
  Future<void> watchFav(
      {required String userId,
      required FirebaseUserPaths path,
      required MovieDetaleModel model,
      CommentModel? comment,
      bool? update,
      required bool upload}) async {
    update != null
        ? await _ref
            .doc(userId)
            .collection(path.name)
            .doc(comment != null ? comment.commentId : model.id.toString())
            .update(comment != null ? comment.toMap() : model.toMap())
        : upload
            ? await _ref
                .doc(userId)
                .collection(path.name)
                .doc(comment != null ? comment.commentId : model.id.toString())
                .set(comment != null ? comment.toMap() : model.toMap())
            : await _ref
                .doc(userId)
                .collection(path.name)
                .doc(comment != null ? comment.commentId : model.id.toString())
                .delete();
  }

  // read , upoload , update comments
  Future<(QuerySnapshot?, bool? doneUpload)> keepComment(
      {required FirebaseMainPaths path,
      required String movieId,
      String? commentId,
      String? repId,
      required CommentState state,
      required bool reply,
      Map<String, dynamic>? map}) async {
    if (state == CommentState.upload) {
      if (reply) {
        await _refOther
            .doc(movieId)
            .collection(path.name)
            .doc(commentId)
            .collection('replies')
            .doc(repId)
            .set(map as Map<String, dynamic>);
      } else {
        await _refOther
            .doc(movieId)
            .collection(path.name)
            .doc(commentId)
            .set(map as Map<String, dynamic>);
      }
      return (null, true);
    } else if (state == CommentState.update) {
      if (reply) {
        await _refOther
            .doc(movieId)
            .collection(path.name)
            .doc(commentId)
            .collection('replies')
            .doc(repId)
            .update(map as Map<String, dynamic>);
      } else {
        await _refOther
            .doc(movieId)
            .collection(path.name)
            .doc(commentId)
            .update(map as Map<String, dynamic>);
      }
      return (null, true);
    } else if (state == CommentState.delete) {
      if (reply) {
        await _refOther
            .doc(movieId)
            .collection(path.name)
            .doc(commentId)
            .collection('replies')
            .doc(repId)
            .delete();
      } else {
        await _refOther
            .doc(movieId)
            .collection(path.name)
            .doc(commentId)
            .delete();
      }
      return (null, true);
    } else {
      return (
        reply
            ? await _refOther
                .doc(movieId)
                .collection(path.name)
                .doc(commentId)
                .collection('replies')
                .get()
            : await _refOther.doc(movieId).collection(path.name).get(),
        null
      );
    }
  }

  // get favorites or watchlist or watching now
  Future<QuerySnapshot> userCollections(
      {required String uid,
      required String collection,
      required bool order,
      String? orderby,
      bool? ascend}) async {
    return order
        ? _ref
            .doc(uid)
            .collection(collection)
            .orderBy(orderby.toString(),
                descending: ascend == false ? true : false)
            .get()
        : _ref.doc(uid).collection(collection).get();
  }
}
