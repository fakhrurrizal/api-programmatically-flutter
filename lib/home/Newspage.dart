import 'package:flutter/material.dart';
import 'package:praktikum_9_api/home/apiPage/NewsCard.dart';
import 'package:praktikum_9_api/model/GetNews.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<GetNews>> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var getPostsData = json.decode(response.body) as List;
      var listPosts = getPostsData.map((e) => GetNews.fromJson(e)).toList();

      return listPosts;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  late Future<List<GetNews>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder(
                  future: futurePosts,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        itemBuilder: ((context, index) {
                          var post = (snapshot.data as List<GetNews>)[index];
                          return Column(children: [
                            Newscard(
                                getnews: GetNews(
                                    id: post.id,
                                    title: post.title,
                                    body: post.body)),
                            const SizedBox(
                              height: 20,
                            )
                          ]);
                        }),
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: (snapshot.data as List<GetNews>).length,
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  })))),
    );
  }
}
