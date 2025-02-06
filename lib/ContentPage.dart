import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsweather_app/models/newsArticle.dart';

class Contentpage extends StatefulWidget {
  final Newsarticle newsarticle;

  const Contentpage({
    super.key,
    required this.newsarticle,
  });

  @override
  State<Contentpage> createState() => _ContentpageState();
}

class _ContentpageState extends State<Contentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4, // 40% height
              width: double.infinity,
              child: Image.network(
                widget.newsarticle.urlToImage,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 7, top: 10, bottom: 0, right: 0),
              child: Row(
                //
                children: [
                  Text(
                    "${widget.newsarticle.author}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    maxLines: 1,
                  ),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 7, top: 10, bottom: 0, right: 0),
              child: Row(
                children: [
                  Text(
                    maxLines: 1,
                    "${DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.parse(widget.newsarticle.publishedAt))}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "${widget.newsarticle.title}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "${widget.newsarticle.content}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            widget.newsarticle.bookmark = true;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Article added to bookmarks.'),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                );
              },
            );
          },
          child: Icon(
            Icons.bookmark,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_down_rounded),
            label: 'Save',
          ),
        ],
      ),
    );
  }
}
