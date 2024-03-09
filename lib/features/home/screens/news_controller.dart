import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/home/screens/news.dart';
import 'package:one/features/home/screens/news_repository.dart';
import 'package:uuid/uuid.dart';

final newsControllerProvider =
    StateNotifierProvider<NewsController, bool>((ref) {
  final newsRepository = ref.watch(newsRepositoryProvider);
  return NewsController(newsRepository: newsRepository, ref: ref);
});

final newsProvider = StreamProvider((ref) {
  final newsController = ref.watch(newsControllerProvider.notifier);
  return newsController.fetchNews();
});

class NewsController extends StateNotifier<bool> {
  final NewsRepository _newsRepository;
  final Ref _ref;

  NewsController({
    required NewsRepository newsRepository,
    required Ref ref,
  })  : _newsRepository = newsRepository,
        _ref = ref,
        super(false); //for loading status

  Future<String> addNews({
    required BuildContext context,
    required String title,
    required String description,
    List<String>? tags,
    String? attachment,
  }) async {
    state = true;
    String newsId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final News news = News(
      id: newsId,
      title: title,
      description: description,
      sentBy: user.name,
      timestamp: DateTime.now(),
    );

    if (user.roles?.contains("Dev") ?? false) {
      final res = await _newsRepository.addNews(news);
      state = false;
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'news added successfully!');
          // Routemaster.of(context).pop();
        },
      );
    } else {
      showSnackBar(context, "you can't");
    }
    return newsId;
  }

  Stream<List<News>> fetchNews() {
    return _newsRepository.fetchNews();
  }

  Future<void> deletNews(String id) {
    return _newsRepository.deleteNews(id);
  }

  Stream<News> getNews(String id) {
    return _newsRepository.getNews(id);
  }
}
