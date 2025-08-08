import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restapi_covidapp/Models/users_model.dart';
import 'package:http/http.dart' as http;
import 'package:restapi_covidapp/widgets/resuable_row.dart';

class Ex3RestapiScreen extends StatefulWidget {
  const Ex3RestapiScreen({super.key});

  @override
  State<Ex3RestapiScreen> createState() => _Ex3RestapiScreenState();
}

class _Ex3RestapiScreenState extends State<Ex3RestapiScreen> {
  List<UsersModel> usersList = [];

  Future<List<UsersModel>> getUsersApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
        headers: {
          'User-Agent': 'FlutterApp/1.0', // Optional header for identification
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body.toString());
        usersList.clear();
        print(data);
        for (Map<String, dynamic> i in data) {
          print(i['name']);
          usersList.add(UsersModel.fromJson(i));
        }
        return usersList;
      } else {
        throw Exception('Failed to Load users data');
      }
    } catch (e) {
      print('Error occured : $e');
      throw Exception('Failed to load users data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users Api')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FutureBuilder(
                future: getUsersApi(),
                builder: (context, AsyncSnapshot<List<UsersModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: usersList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Column(
                              children: [
                                ResuableRow(
                                  title: 'Name',
                                  value: snapshot.data![index].name.toString(),
                                ),
                                ResuableRow(
                                  title: 'Username',
                                  value: snapshot.data![index].username
                                      .toString(),
                                ),
                                ResuableRow(
                                  title: 'Email',
                                  value: snapshot.data![index].email.toString(),
                                ),
                                ResuableRow(
                                  title: 'Geo',
                                  value: snapshot.data![index].address!.geo!.lat
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
