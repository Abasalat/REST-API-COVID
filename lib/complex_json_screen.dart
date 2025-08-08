import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restapi_covidapp/Models/products_model.dart';
import 'package:http/http.dart' as http;
import 'package:restapi_covidapp/Models/users_model.dart';

class ComplexJsonScreen extends StatefulWidget {
  const ComplexJsonScreen({super.key});

  @override
  State<ComplexJsonScreen> createState() => _ComplexJsonScreenState();
}

class _ComplexJsonScreenState extends State<ComplexJsonScreen> {
  Future<ProductsModel> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://webhook.site/43d15272-d0f2-4857-81ad-a0fe0e21e231'),
        headers: {
          'User-Agent': 'FlutterApp/1.0', // Optional header for identification
          'Content-Type': 'application/json',
        },
      );

      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        return ProductsModel.fromJson(data);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complex Json')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchProducts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .3,
                            width: MediaQuery.of(context).size.width * 1,

                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  snapshot.data.data![index].images!.length,
                              itemBuilder: (context, imageIndex) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        .25,
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot
                                              .data
                                              .data![index]
                                              .images![imageIndex]
                                              .url
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
