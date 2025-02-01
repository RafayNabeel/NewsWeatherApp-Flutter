class Newsarticle {
  final String id;
  final String name;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  bool bookmark;

  Newsarticle({
    required this.id,
    required this.name,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    this.bookmark = false,
  });

  // Convert a JSON map to a Newsarticle object
  factory Newsarticle.fromJson(Map<String, dynamic> json) {
    return Newsarticle(
      id: json['id'] as String? ?? '', // Default to empty string if null
      name: json['name'] as String? ?? '', // Default to empty string if null
      author:
          json['author'] as String? ?? '', // Default to empty string if null
      title: json['title'] as String? ?? '', // Default to empty string if null
      description: json['description'] as String? ??
          '', // Default to empty string if null
      url: json['url'] as String? ?? '', // Default to empty string if null
      urlToImage: json['urlToImage'] as String? ??
          '', // Default to empty string if null
      publishedAt: json['publishedAt'] as String? ?? '',
      content:
          json['content'] as String? ?? '', // Default to empty string if null
    );
  }

  // Convert a Newsarticle object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
  // rafay == rafay

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Newsarticle &&
        other.id == id &&
        other.name == name &&
        other.author == author &&
        other.title == title &&
        other.description == description &&
        other.url == url &&
        other.urlToImage == urlToImage &&
        other.publishedAt == publishedAt &&
        other.content == content &&
        other.bookmark == bookmark;
  }

  // Override hashCode
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        author.hashCode ^
        title.hashCode ^
        description.hashCode ^
        url.hashCode ^
        urlToImage.hashCode ^
        publishedAt.hashCode ^
        content.hashCode ^
        bookmark.hashCode;
  }
}