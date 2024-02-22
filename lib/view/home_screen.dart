import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, aryNews, wired, abcNews}

class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu; 


  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
          }, 
          icon: Image.asset('images/category_icon.png',
          height: 20,
          width: 20,
          ),
          ),
        title: Text('News', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert, color: Colors.black,),
            onSelected: (FilterList item) {
              if(FilterList.bbcNews.name == item.name){
                name = 'bbc-news';
              }
              if(FilterList.aryNews.name == item.name ){
                name = 'ary-news';
              }
              if(FilterList.wired.name  == item.name){
                name = 'wired';
              }
              if(FilterList.abcNews.name == item.name){
                name = 'abc-news';
              }

              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>> [
              const PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text('Ary News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.wired,
                child: Text('Wired'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.abcNews,
                child: Text('ABC News'),
              ),
            ],
            )
        ],
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: () async{
          setState(() {
            
          });
        },
        child: ListView(
        children: [
          SizedBox(
            height: height * .5,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: NewsRepository().fetchNewsChannelHeadlinesApi(name),
              builder:(BuildContext context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: const Padding(
                        padding:  EdgeInsets.all(16.0),
                        child:  Text('No Internet Connection',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                      ),
                    )
                  );
                }else{
                  // var connectivityResult = snapshot.data;
                  // if(connectivityResult == ConnectivityResult.none){
                  //   return Center(
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //             content: const Text('No internet connection'),
                  //             action: SnackBarAction(
                  //               label: 'Dismiss',
                  //               onPressed: () {},
                  //             ),
                  //           ),
                  //         );
                  //       }, 
                  //       child: Text('Network Error'),
                  //       ),
                  //   );
                  // }else {

                  // }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index){

                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> 
                            NewsDetailScreen(
                              newImage: snapshot.data!.articles![index].urlToImage.toString(), 
                              newsTitle: snapshot.data!.articles![index].title.toString(), 
                              newsData: snapshot.data!.articles![index].publishedAt.toString(), 
                              author: snapshot.data!.articles![index].author.toString(), 
                              description: snapshot.data!.articles![index].description.toString(), 
                              content: snapshot.data!.articles![index].content.toString(), 
                              source: snapshot.data!.articles![index].source!.name.toString()
                            ))
                          );
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.6,
                                width: width * .9,
                                padding: EdgeInsets.symmetric(
                                  horizontal: height * .02,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: spinKit2,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    alignment: Alignment.bottomCenter,
                                    height: height * .22,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          child: Text(snapshot.data!.articles![index].title.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: width *0.7,
                                          child: Text(snapshot.data!.articles![index].content.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
                                              ),
                                              Text(format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
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
                        ),
                      );
                    } 
                  );
                }
              } 
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchCategoriesNewsApi('General'),
                  builder:(BuildContext context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.blue,
                        ),
                      );
                    }else if(snapshot.hasError){
                      return const SizedBox();
                    }else{
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index){
                
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                                NewsDetailScreen(
                                newImage: snapshot.data!.articles![index].urlToImage.toString(), 
                                newsTitle: snapshot.data!.articles![index].title.toString(), 
                                newsData: snapshot.data!.articles![index].publishedAt.toString(), 
                                author: snapshot.data!.articles![index].author.toString(), 
                                description: snapshot.data!.articles![index].description.toString(), 
                                content: snapshot.data!.articles![index].content.toString(), 
                                source: snapshot.data!.articles![index].source!.name.toString()
                                ),
                                ));
                              },
                              child: Container(
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromARGB(255, 223, 223, 223),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                            fit: BoxFit.cover,
                                            height:  height * .18,
                                            width: width * .3,
                                            
                                            placeholder: (context, url) => Container(
                                              child: const Center(
                                                    child: SpinKitCircle(
                                                      size: 50,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                            ),
                                            errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: height * .18,
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              children: [
                                                Text(snapshot.data!.articles![index].title.toString(),
                                                maxLines: 3,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.person_pin_circle_rounded,
                                                      color: Colors.green,
                                                      ),
                                                      Text(snapshot.data!.articles![index].source!.name.toString(),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          color: Colors.green,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(format.format(dateTime),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } 
                        );
                    }
                  } 
                  ),
          ),
        ],
      ),
        ),
      
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);