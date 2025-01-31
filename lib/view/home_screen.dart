import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_news_app/model/news_channels_headlines_model.dart';
import 'package:my_news_app/view/categories_screen.dart';
import '../model/categories_new_model.dart';
import '../view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, aryNews, crypto, entertainment, espn, cricinfo}
class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String name = 'bbc-news';
  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: null,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
            },
            icon: Image.asset(
              'images/category_icon.png',
              height: 30,
              width: 30,
            ),
          ),
          title: Text(
            'News',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton<FilterList>(
                initialValue: selectedMenu,
                icon: const Icon(Icons.more_vert,color: Colors.black,),
                onSelected: (FilterList item){
                  if(FilterList.bbcNews.name == item.name){
                    name = 'bbc-news';
                  }
                  if(FilterList.aryNews.name == item.name){
                    name = 'ary-news';
                  }
                  if(FilterList.crypto.name == item.name){
                    name = 'crypto-coins-news';
                  }
                  if(FilterList.entertainment.name == item.name){
                    name = 'entertainment-weekly';
                  }
                  if(FilterList.espn.name == item.name){
                    name = 'espn';
                  }
                  if(FilterList.cricinfo.name == item.name){
                    name = 'espn-cric-info';
                  }
                  setState(() {
                    selectedMenu = item;
                  });
                },
                itemBuilder: (context) => <PopupMenuEntry<FilterList>> [
                  const PopupMenuItem<FilterList>(
                   value: FilterList.bbcNews,
                  child: Text('BBC NEWS')
              ),
                  const PopupMenuItem<FilterList>(
                      value: FilterList.aryNews,
                      child: Text('Ary NEWS')
                  ),
                  const PopupMenuItem(
                      value: FilterList.crypto,
                      child: Text('CRYPTO NEWS')
                  ),
                  const PopupMenuItem(
                      value: FilterList.entertainment,
                      child: Text('ENTERTAINMENTWEEKLY NEWS')
                  ),
                  const PopupMenuItem(
                      value: FilterList.espn,
                      child: Text('ESPN NEWS')
                  ),
                  const PopupMenuItem(
                      value: FilterList.cricinfo,
                      child: Text('ESPN CRIC INFO NEWS')
                  ),
            ])
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: height * .55,
              width: width,
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * .6,
                                  width: width * .9,
                                  padding: EdgeInsets.symmetric(horizontal: height * .02),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: spinKit2,
                                      ),
                                      errorWidget: (context, url, error) => const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: const EdgeInsets.all(15),
                                      height: height * .22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot.data!.articles![index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!.articles![index].source!.name!.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13, fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  format.format(datetime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                         }
                        );
                  }
                },
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi('General'),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    height: height * 0.25,
                                    width: width * 0.40,
                                    placeholder: (context, url) => Container(
                                      child: spinKit2,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                      height: height * 0.25,
                                      padding : const EdgeInsets.only(left: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start, // Add mainAxisAlignment here
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),maxLines: 3,style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,
                                          ),),
                                          const Spacer(),
                                          Text(snapshot.data!.articles![index].source!.name.toString(),style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),),
                                          Text(format.format(datetime),maxLines: 3,style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),)
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
