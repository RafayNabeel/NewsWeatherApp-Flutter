import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsweather_app/ContentPage.dart';
import 'package:newsweather_app/bookmarks.dart';
import 'package:newsweather_app/components/bottomNavBar.dart';

import 'package:newsweather_app/models/newsArticle.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Newsarticle> articlesList = [];
  final String cat = '';
  final List<String> categories = [
    'General',
    'Technology',
    'Business',
    'Education',
    'Health'
  ];

  Future<void> writeBookmarks(Newsarticle article) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> storedBookmarks = preferences.getStringList('bookmarks') ?? [];

    Map<String, dynamic> smallArticle = {
      'title': article.title,
      'url': article.url,
      'urlToImage': article.urlToImage
    };

    storedBookmarks.add(jsonEncode(smallArticle));
    await preferences.setStringList('bookmarks', storedBookmarks);
  }

  List<Newsarticle> bookmarkedList(List<Newsarticle> articles) {
    List<Newsarticle> newArticleList = [];
    for (int i = 0; i < articles.length; i++) {
      if (articles[i].bookmark == true) {
        newArticleList.add(articles[i]);
        print("${articles[i].title} bookmarked.");
      }
    }

    return newArticleList;
  }

  // Future<void> writeBookmarkList(Newsarticle article) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   List<String> storedBookmarks = preferences.getStringList('bookmarks') ?? [];

  //   // Convert the article to JSON
  //   String articleJson = jsonEncode(article.toJson());

  //   print("Article Json : ${articleJson}");

  //   // is bookmarked?
  //   // if (storedBookmarks.any(article))

  //   // Add it to the list of bookmarks
  //   storedBookmarks.add(articleJson);

  //   // Save the updated list back to SharedPreferences
  //   await preferences.setStringList('bookmarks', storedBookmarks);
  // }

  Future<void> writeBookmarkedArticles(Newsarticle article) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> storedBookmarks = preferences.getStringList('bookmarks') ?? [];

    // Prevent duplicate bookmarks
    bool alreadyBookmarked = storedBookmarks.any((jsonString) {
      var existingArticle = jsonDecode(jsonString);
      return existingArticle['title'] == article.title &&
          existingArticle['url'] == article.url;
    });

    if (!alreadyBookmarked) {
      storedBookmarks.add(jsonEncode(article.toJson()));
      await preferences.setStringList('bookmarks', storedBookmarks);
      print("Bookmarked: ${article.title}");
    } else {
      print("Already Bookmarked: ${article.title}");
    }
  }

  // we want to store
  // title (String)
  // url (String)
  // urlToImage(String)

  // in the sharedPreferences,
  // Check : if (articleList[index].title == list.title || )
  //         (articleList[index].url == list.url || )
  // the above check will cause the bookmark to not be repeated

  // Fetch the content on click from the three parameters above.
  // Shared preferences will ultimately use less memory.

  final String id = '';
  final String name = '';
  final String author = '';
  final String title = '';
  final String description = '';
  final String url = '';
  final String urlToImage = '';
  final String publishedAt = '';
  final String content = '';
  bool bookmark = false;

  Future<void> displayArticles(String category) async {
    String url = '';

    print("${category} is the passed parameter.");

    switch (category) {
      case 'General':
        url =
            "https://newsapi.org/v2/top-headlines?category=general&apiKey=5c220e53f24548acac17a59491e6fee1";
        break;
      case 'Technology':
        url =
            "https://newsapi.org/v2/top-headlines?category=technology&apiKey=5c220e53f24548acac17a59491e6fee1";
        break;
      case 'Business':
        url =
            "https://newsapi.org/v2/top-headlines?category=business&apiKey=5c220e53f24548acac17a59491e6fee1";
        break;
      case 'Education':
        url =
            "https://newsapi.org/v2/top-headlines?category=education&apiKey=5c220e53f24548acac17a59491e6fee1";
        break;
      case 'Health':
        url =
            "https://newsapi.org/v2/top-headlines?category=health&apiKey=5c220e53f24548acac17a59491e6fee1";
        break;

      default:
        url =
            "https://newsapi.org/v2/top-headlines?category=general&apiKey=5c220e53f24548acac17a59491e6fee1";
        break;
    }

    print(url);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        print("Final URL : ${url}");
        Map<String, dynamic> map = jsonDecode(response.body);
        int total = map['totalResults'];
        articlesList = (map['articles'] as List)
            .map((item) => Newsarticle.fromJson(item))
            .toList();

        print("total results : ${total}");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displayArticles(cat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              // pop back to the previous screen which is the ForYouPage
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined)),
        actions: [
          IconButton(
            onPressed: () {
              // Load bookmarks
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Bookmarks(),
                ),
              );
            },
            icon: Icon(Icons.bookmark_added),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal Scrollable Categories
          // Row -> Chip -> Label with text of category , wrap row with singleChildScroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        displayArticles(category);
                        print("${category} pressed");
                      },
                      child: Chip(
                        label: Text(category),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          articlesList.isEmpty
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: articlesList.length,
                    itemBuilder: (context, index) => GestureDetector(
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Contentpage(
                                            newsarticle: articlesList[index]),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 120,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      "${articlesList[index].urlToImage}",
                                      fit: BoxFit.fill,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child:
                                                CupertinoActivityIndicator());
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 50,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${articlesList[index].title}  ",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                        maxLines: 2),
                                    Text(
                                      "${articlesList[index].description}  ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      "${articlesList[index].author}  ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      "${articlesList[index].publishedAt}  ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  setState(() {
                                    articlesList[index].bookmark = true;
                                    print(
                                        "${articlesList[index].title} is bookmarked.");
                                    bookmarkedList(articlesList);
                                  });
                                  print(bookmarkedList(articlesList));

                                  writeBookmarkedArticles(articlesList[index]);
                                  //   writeBookmarkList(
                                  //       articlesList[index].id,
                                  //       articlesList[index].name,
                                  //       articlesList[index].author,
                                  //       articlesList[index].title,
                                  //       articlesList[index].description,
                                  //       articlesList[index].publishedAt,
                                  //       articlesList[index].url,
                                  //       articlesList[index].urlToImage,
                                  //       articlesList[index].content,
                                  //       articlesList[index].bookmark);
                                  // },
                                },
                                icon: Icon(
                                  Icons.bookmark,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
