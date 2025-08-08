import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestapiWithoutModel extends StatefulWidget {
  const RestapiWithoutModel({super.key});

  @override
  State<RestapiWithoutModel> createState() => _RestapiWithoutModelState();
}

class _RestapiWithoutModelState extends State<RestapiWithoutModel> {
  List<dynamic> data = [];

  // Fetch data from API
  Future<void> getData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
        headers: {
          'User-Agent': 'FlutterApp/1.0', // Optional header for identification
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          // Parse and store data
          data = jsonDecode(response.body.toString());
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is initialized
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rest API without Model')),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]['name']),
                  subtitle: Text(data[index]['email']),
                );
              },
            ),
    );
  }
}
