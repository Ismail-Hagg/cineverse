import 'dart:io';

import 'package:cineverse/models/chat_message_model.dart';
import 'package:cineverse/models/comment_model.dart';
import 'package:cineverse/models/episode_omdel.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/notification_action_model.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class FirebaseServices {
  final CollectionReference _ref = FirebaseFirestore.instance.collection(
      '${FirebaseMainPaths.users.name[0].toUpperCase()}${FirebaseMainPaths.users.name.substring(1)}');

  CollectionReference get ref => _ref;

  final CollectionReference _refOther =
      FirebaseFirestore.instance.collection(FirebaseMainPaths.other.name);

  CollectionReference get refOther => _refOther;

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }

  // get show keeping details from the other collection
  Future<DocumentSnapshot> getKeepingDetale({required String movieId}) async {
    return await _refOther.doc(movieId).get();
  }

  // update show keeping details in the other collection
  Future<void> updateKeepingDetale(
      {required String movieId, required Map<String, dynamic> map}) async {
    await _refOther.doc(movieId).update(map);
  }

  // add user data to firebase
  Future<void> addUsers(UserModel model) async {
    return await _ref.doc(model.userId).set(model.toMap());
  }

  // update user data
  Future<void> userUpdate(
      {required String userId, required Map<String, dynamic> map}) async {
    await _ref.doc(userId).update(map);
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

  // upload and or update notification
  Future<void> uploadNotification(
      {required String userId,
      required String collection,
      required NotificationAction action}) async {
    await _ref.doc(userId).collection(collection).doc().set(action.toMap());
  }

  // update notification
  Future<void> updateNotification(
      {required String userId,
      required String collection,
      required String id,
      required NotificationAction action}) async {
    try {
      await _ref
          .doc(userId)
          .collection(collection)
          .doc(id)
          .update({'open': true});
    } catch (e) {
      print('===== $e ');
    }
  }

  // stream a specific chats
  Stream<QuerySnapshot> getUserChat(
      {required String userId, required String otherId}) {
    return _ref
        .doc(userId)
        .collection(FirebaseUserPaths.chat.name)
        .where('userId', isEqualTo: otherId)
        .snapshots();
  }

  // stream all chats
  Stream<QuerySnapshot> getAllChats(
      {required String userId, String? otherStream}) {
    return _ref
        .doc(userId)
        .collection(otherStream ?? FirebaseUserPaths.chat.name)
        .snapshots();
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

  // send chat message to firebase
  Future<void> sendMessage({required ChatMessageModel model}) async {
    await _ref
        .doc(model.userId)
        .collection('chat')
        .doc(model.otherId)
        .set(model.toMap());
  }

  // change username or profile pic
  Future<bool> userChanging({required Map<String, dynamic> map}) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('userChanging');
    try {
      final response = await callable.call(map);

      return response.data == null ? false : true;
    } catch (e) {
      print('==> Error: $e');
      return false;
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

  // get document from a collection
  Future<DocumentSnapshot> userDocument(
      {required String uid,
      required String collection,
      required String docId}) async {
    return await _ref.doc(uid).collection(collection).doc(docId).get();
  }

  // add to episode keeping
  Future<void> addEpisodeMe(
      {required String uid, required EpisodeModeL model, bool? update}) async {
    update == null
        ? await _ref
            .doc(uid)
            .collection(FirebaseUserPaths.keeping.name)
            .doc(model.id.toString())
            .set(model.toMap())
        : await _ref
            .doc(uid)
            .collection(FirebaseUserPaths.keeping.name)
            .doc(model.id.toString())
            .update(model.toMap());
  }

  // get the show data from the 'other' collection
  Future<DocumentSnapshot> getShowData({required String showId}) async {
    return await _refOther.doc(showId).get();
  }

  // add show data to the 'other' collection
  Future<void> addShowData({required EpisodeModeL model}) async {
    return await _refOther.doc(model.id.toString()).set(model.toMap());
  }

  // update show data from the 'other' collection
  Future<void> updateShowData(
      {required String showId, required Map<String, dynamic> map}) async {
    await _refOther.doc(showId).update(map);
  }

  Future<void> delDoc(
      {required String uid,
      required String collection,
      required String docId}) async {
    await _ref.doc(uid).collection(collection).doc(docId).delete();
  }

  // get comments from the other ref
  Future<QuerySnapshot> getOtherComments({required String movieId}) async {
    return _refOther.doc(movieId).collection('comments').get();
  }

  // chear isUpdated
  Future<void> clearIsUpdates(
      {required String userId, required String chatId}) {
    return _ref
        .doc(userId)
        .collection(FirebaseUserPaths.chat.name)
        .doc(chatId)
        .update({'isUpdated': false});
  }
}
