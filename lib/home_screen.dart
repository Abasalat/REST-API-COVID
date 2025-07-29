import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Add this import for JSON parsing
import 'package:restapi_covidapp/Models/posts_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostsModel> postList = [];

  // Using http package to get data from API
  Future<List<PostsModel>> getPostApi() async {
    try {
      // Making the GET request with custom headers
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          'User-Agent': 'FlutterApp/1.0', // Optional header for identification
          'Content-Type': 'application/json',
        },
      );

      // Debugging: print the raw response for inspection
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        postList.clear();
        final List<dynamic> data = jsonDecode(response.body);

        for (Map<String, dynamic> i in data) {
          postList.add(PostsModel.fromJson(i));
        }
        return postList;
      } else {
        // Debugging: print more details about the error
        print('Error: ${response.statusCode}');
        throw Exception(
          'Failed to load posts. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handling errors and displaying the message
      print('Error occurred: $e');
      throw Exception('Failed to load posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('COVID_19 Tracker')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, AsyncSnapshot<List<PostsModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Post ${postList[index].id.toString()}: ${postList[index].title.toString()}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
