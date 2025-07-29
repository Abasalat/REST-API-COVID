import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomModelScreen extends StatefulWidget {
  const CustomModelScreen({super.key});

  @override
  State<CustomModelScreen> createState() => _CustomModelScreenState();
}

class _CustomModelScreenState extends State<CustomModelScreen> {
  List<CustomModel> photosList = [];

  Future<List<CustomModel>> getPhotosApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/photos'),
        headers: {
          'User-Agent': 'FlutterApp/1.0', // Optional header for identification
          'Content-Type': 'application/json',
        },
      );

      final List<dynamic> data = jsonDecode(response.body.toString());
      // Debugging: print the raw response for inspection
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        photosList.clear();
        for (Map<String, dynamic> i in data) {
          CustomModel photos = CustomModel(title: i['title'], url: i['url']);
          print('Fetched URL: ${i['url']}');
          photosList.add(photos);
        }
        return photosList;
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      print('Error occured: $e');
      throw Exception('Faiiled to load photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Model')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPhotosApi(),
              builder: (context, AsyncSnapshot<List<CustomModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data![index].url,
                          ),
                        ),
                        title: Text(snapshot.data![index].title),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomModel {
  String title, url;

  CustomModel({required this.title, required this.url});
}
