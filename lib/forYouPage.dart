import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsweather_app/ContentPage.dart';

import 'package:newsweather_app/components/bottomNavBar.dart';

import 'package:newsweather_app/models/newsArticle.dart';
import 'package:newsweather_app/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Foryoupage extends StatefulWidget {
  const Foryoupage({super.key});

  @override
  State<Foryoupage> createState() => _ForyoupageState();
}

class _ForyoupageState extends State<Foryoupage> {
  // make a map for the jSON data

  // list for the articles
  List<Newsarticle> newsList = [];
  late bool isLoading = false;

  // textController to search through the api

  final TextEditingController searchController = TextEditingController();
  // default search
  bool searchByTitle = true;

  int page = 1;

  Future<void> apiHit() async {
    String url =
        "https://newsapi.org/v2/everything?q=bitcoin&page=$page&apiKey=5c220e53f24548acac17a59491e6fee1";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = jsonDecode(response.body);

        int totalResults = map['totalResults'];
        print(totalResults);
        print(page);
        newsList = (map['articles'] as List)
            .map((item) => Newsarticle.fromJson(item as Map<String, dynamic>))
            .toList();

        // n
      });
    }
  }

  Future<void> titleOrDomainSearch() async {
    final String query = searchController.text.trim();

    if (query.isEmpty) {
      print("Empty , nothing to return");
      return;
    }

    if (searchByTitle == true) {
      final url = Uri.parse(
          "https://newsapi.org/v2/everything?q=$query&page=$page&apiKey=5c220e53f24548acac17a59491e6fee1");

      final response = await http.get(url);

      setState(() {
        isLoading = true; // Show loading indicator when search starts
      });

      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> map = jsonDecode(response.body);

          int totalResults = map['totalResults'];
          print("Into Title Search Func");
          print(totalResults);
          print(page);

          newsList = (map['articles'] as List)
              .map((item) => Newsarticle.fromJson(item as Map<String, dynamic>))
              .toList();

          print(newsList);
          print(newsList.length);
        });
      } else {
        // Handle non-200 status code
        print("Error: ${response.statusCode}");
      }
    } else {
      final url = Uri.parse(
          "https://newsapi.org/v2/everything?q=$query&page=$page&apiKey=5c220e53f24548acac17a59491e6fee1");

      final response = await http.get(url);

      setState(() {
        isLoading = true; // Show loading indicator when search starts
      });

      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> map = jsonDecode(response.body);

          int totalResults = map['totalResults'];

          print("Into domain search");
          print(totalResults);
          print(page);

          newsList = (map['articles'] as List)
              .map((item) => Newsarticle.fromJson(item as Map<String, dynamic>))
              .toList();

          print(newsList);
          print(newsList.length);
        });
      } else {
        // Handle non-200 status code
        print("Error: ${response.statusCode}");
      }
    }
  }

  //
  @override
  void initState() {
    super.initState();
    apiHit();
  }

  @override
  Widget build(BuildContext context) {
    // get the search query
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "For You",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Logged out successfully")),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Welcomepage()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: newsList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, right: 5, bottom: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Contentpage(
                                newsarticle: newsList[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          height: 220,
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              "${newsList[index].urlToImage}",
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CupertinoActivityIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
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
                      const SizedBox(height: 20),

                      // Content Section
                      Text(
                        "${newsList[index].id}",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${newsList[index].title}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${newsList[index].description}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${newsList[index].author}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                GestureDetector(
                  onTap: () {
                    // Add functionality for the Previous button
                    if (page > 1) {
                      page--;
                    }
                    print("Previous pressed");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Previous',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                // Next Button
                GestureDetector(
                  onTap: () {
                    page++;
                    print("Next pressed");
                    apiHit();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 65,
                  width: 340,
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: searchByTitle
                          ? "Search by title"
                          : "Search by domain",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                searchByTitle = !searchByTitle;
                              });
                            },
                            icon: searchByTitle
                                ? Icon(Icons.title)
                                : Icon(Icons.description),
                          ),
                          // Icon for search

                          // can implement search logic here by calling
                          // the future api functions
                          // if searchByTitle == true , then qInTitle Query Hit (future function)
                          // if searchByTitle == false , then qInDescription Query Hit
                          IconButton(
                            onPressed: () {
                              titleOrDomainSearch();
                            },
                            icon: Icon(
                              Icons.search,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
