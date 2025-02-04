import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_news_app/model/categories_new_model.dart';
import '../view_model/news_view_model.dart';
import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  NewsViewModel newsViewModel = NewsViewModel();
  String categoryName = 'General';
  final format = DateFormat('MMMM dd, yyyy');

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        categoryName = categoriesList[index];
                        setState(() {

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: categoryName == categoriesList[index] ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(child: Text(categoriesList[index].toString(), style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white
                            ), )),
                          ),
                        ),
                      ),
                    );
              }),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
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
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                    height: height * 0.25,
                                    padding : EdgeInsets.only(left: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start, // Add mainAxisAlignment here
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString(),maxLines: 3,style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,
                                      ),),
                                      Spacer(),
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
        ),
      ),
    );
  }
}
