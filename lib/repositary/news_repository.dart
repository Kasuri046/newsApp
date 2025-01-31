import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:my_news_app/model/news_channels_headlines_model.dart';

import '../model/categories_new_model.dart';

class NewsRepository{


  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName)async{
    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=535e9bd1f45e47c996147a1e6da5f816' ;
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }throw Exception('Error');
  }


  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=535e9bd1f45e47c996147a1e6da5f816';
    print(url);
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }throw Exception('Error');
  }

}