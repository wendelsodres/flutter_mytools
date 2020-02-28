import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytools/product_detail.dart';
import 'package:transparent_image/transparent_image.dart';

class BuscadorGif extends StatefulWidget {
  @override
  _BuscadorGifState createState() => _BuscadorGifState();
}

class _BuscadorGifState extends State<BuscadorGif> {
  String _search;

  Future<dynamic> _getGifs() async {
    http.Response response;

    ///api/catalog_system/pvt/category/tree/ catalogo
    if (_search == null || _search.isEmpty)
      response = await http.get(
          'https://www.rihappy.com.br/api/catalog_system/pub/products/search?fq=C:738');
    else
      response = await http.get(
          'https://www.rihappy.com.br/api/catalog_system/pub/products/search/$_search');

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: 10,
        itemBuilder: (context, index) {
          if (snapshot.data[index]['items'][0]['sellers'][0]['commertialOffer']
                  ['Price'] !=
              "0") {
            return GestureDetector(
              child: Column(
                children: <Widget>[
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data[index]['items'][0]['images'][0]
                        ['imageUrl'],
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      snapshot.data[index]['items'][0]['name'],
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "R\$ ${snapshot.data[index]['items'][0]['sellers'][0]['commertialOffer']['Price']}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf26451)),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetail(snapshot.data[index]['items'])));
              },
            );
          }
        });
  }
}
