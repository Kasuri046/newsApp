import 'package:my_news_app/model/news_channels_headlines_model.dart';
import 'package:my_news_app/repositary/news_repository.dart';

import '../model/categories_new_model.dart';

class NewsViewModel{
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName)async{
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }

}