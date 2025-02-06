import 'package:flutter/material.dart';
import 'package:newsweather_app/ContentPage.dart';
import 'package:newsweather_app/components/bottomNavBar.dart';
import 'dart:convert';
import 'package:newsweather_app/models/newsArticle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List<Newsarticle> bookmarkedArticles = [];

  @override
  void initState() {
    super.initState();
    loadBookmarkedArticles(); // Fetch bookmarks when screen loads
  }

  Future<void> loadBookmarkedArticles() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> storedBookmarks = preferences.getStringList('bookmarks') ?? [];

    List<Newsarticle> loadedBookmarks = storedBookmarks.map((jsonString) {
      return Newsarticle.fromJson(jsonDecode(jsonString));
    }).toList();

    setState(() {
      bookmarkedArticles = loadedBookmarks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          "Bookmarks",
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences pref =
                  await SharedPreferences.getInstance();
              await pref.remove('bookmarks'); // Wait for the async operation

              // Now update UI synchronously
              setState(() {
                bookmarkedArticles.clear();
              });
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: bookmarkedArticles.isEmpty
          ? Center(child: Text("No bookmarks yet!"))
          : ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Contentpage(
                              newsarticle: bookmarkedArticles[index]),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 110,
                        width: 160,
                        child: Image.network(
                          "${bookmarkedArticles[index].urlToImage}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        "${bookmarkedArticles[index].title}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 19,
                            fontWeight: FontWeight.w700),
                        maxLines: 3,
                      ),
                      subtitle: Text(
                        "${bookmarkedArticles[index].author}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
