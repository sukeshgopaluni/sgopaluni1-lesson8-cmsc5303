import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesson6/model/photomemo.dart';

const photoMemoCollection = 'photomemo_collection';

Future<String> addPhotoMemo({required PhotoMemo photoMemo}) async {
  DocumentReference ref = await FirebaseFirestore.instance
      .collection(photoMemoCollection)
      .add(photoMemo.toFirestoreDoc());
  return ref.id;
}

Future<List<PhotoMemo>> getPhotoMemoList({required String email}) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(photoMemoCollection)
      .where(DocKeyPhotoMemo.createdBy.name, isEqualTo: email)
      .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
      .get();
  var result = <PhotoMemo>[];
  for (var doc in querySnapshot.docs) {
    if (doc.data() != null) {
      var document = doc.data() as Map<String, dynamic>;
      var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
      result.add(p);
    }
  }
  return result;
}

Future<void> updatePhotoMemo({
  required String docId,
  required Map<String, dynamic> update,
}) async {
  await FirebaseFirestore.instance
      .collection(photoMemoCollection)
      .doc(docId)
      .update(update);
}

Future<List<PhotoMemo>> getSharedWithList({required String email}) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(photoMemoCollection)
      .where(DocKeyPhotoMemo.sharedWith.name, arrayContains: email)
      .orderBy(DocKeyPhotoMemo.timestamp.name, descending: true)
      .get();
  var result = <PhotoMemo>[];
  for (var doc in querySnapshot.docs) {
    if (doc.data() != null) {
      var document = doc.data() as Map<String, dynamic>;
      var p = PhotoMemo.fromFirestoreDoc(
        doc: document,
        docId: doc.id,
      );
      result.add(p);
    }
  }
  return result;
}

Future<void> deleteDoc({required String docId}) async {
  await FirebaseFirestore.instance
      .collection(photoMemoCollection)
      .doc(docId)
      .delete();
}