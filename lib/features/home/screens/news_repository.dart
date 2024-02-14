import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:one/core/failuer.dart';
import 'package:one/core/providers/firebase_providers.dart';
import 'package:one/core/type_defs.dart';
import 'package:one/features/home/screens/news.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class NewsRepository {
  final FirebaseFirestore _firestore;
  NewsRepository({
    required firestore,
  }) : _firestore = firestore;

  CollectionReference get _news => _firestore.collection("news");

  FutureVoid addNews(News news) async {
    try {
      return right(_news.doc(news.id).set(news.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> deleteNews(String id) async {
    return await _news.doc(id).delete();
  }

  Stream<News> getNews(String id) {
    return _news
        .doc(id)
        .get()
        .then((value) => News.fromMap(value.data() as Map<String, dynamic>))
        .asStream();
  }

  Stream<List<News>> fetchNews() {
    return _news.orderBy('timestamp', descending: true).snapshots().map(
          (event) => event.docs
              .map(
                (e) => News.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
