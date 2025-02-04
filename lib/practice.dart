// Sure! Here’s a similar exercise for practice:

// Imagine you have a list of JSON strings that represent information about books. Each JSON string contains the book's title, author, and year of publication. Your task is to convert these JSON strings into a list of Book objects.

// Each Book class will have the following properties:

// title: The title of the book (String)
// author: The author of the book (String)
// year: The year the book was published (int)
// After converting the JSON strings to Book objects, print out the title and author of each book.

// Create a list of JSON strings, where each string represents a book with the title, author, and year information.
// Use the .map() method to convert each JSON string into a Book object.
// Print the title and author of each book in the list.
// Try implementing this and let me know if you need any help!
import 'dart:convert';

void main() {
  List<String> bookjsonStrings = [
    '{"title" : "Hooked", "author" : "Nir eyal", "year" : 2023}'
  ];

  void makeMap() {
    final map = bookjsonStrings.map((bookObjects) {
      var books = jsonDecode(bookObjects);
      print(books);
    });
  }

  makeMap();
  List<Book> bookObjects = bookjsonStrings.map((books) {
    var bkObj = jsonDecode(books); // this
    print(bkObj);
    var obj2 = jsonEncode(books);
    print(obj2);
    return Book(
        title: bkObj['title'], author: bkObj['author'], year: bkObj['year']);
  }).toList();

  for (var objects in bookObjects) {
    print(
        "Title : ${objects.title}, Author : ${objects.author}, Year : ${objects.year}");
  }

  List<Person> peoples = [
    Person(name: 'Rafay', weight: 83),
    Person(name: 'Talal', weight: 78),
    Person(name: 'Wardah', weight: 55),
  ];

  var peopleNames = peoples.map((names) {
    print("Names : ${names.name}");
  });

  print(peopleNames);

  List<String> peopleMaps = [
    '{"name": "Rafay", "weight": 83}',
    '{ "name": "Talal", "weight": 78}',
  ];

  for (var obj in peopleMaps) {
    print("Name : ${obj}");
  }
}

class Book {
  String title = '';
  String author = '';
  int year = -1;

  Book({
    required this.title,
    required this.author,
    required this.year,
  });
}

class Person {
  final String name;
  final int weight;

  Person({
    required this.name,
    required this.weight,
  });
}
