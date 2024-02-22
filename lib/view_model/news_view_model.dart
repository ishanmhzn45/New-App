

import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {

  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName) async =>  await _rep.fetchNewsChannelHeadlinesApi(channelName);
    


  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}