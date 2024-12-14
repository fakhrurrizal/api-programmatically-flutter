class GetNews {
  int id;
  String title;
  String body;

  GetNews({required this.id, required this.title, required this.body});
  factory GetNews.fromJson(Map<String, dynamic> json) {
    return GetNews(id: json['id'], title: json['title'], body: json['body']);
  }
}
