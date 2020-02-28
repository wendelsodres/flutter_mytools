import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class ConvertCurrency extends StatefulWidget {
  @override
  _ConvertCurrencyState createState() => _ConvertCurrencyState();
}

class _ConvertCurrencyState extends State<ConvertCurrency> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dollarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Convert Currency'),
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black38, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Error data load",
                      style: TextStyle(color: Colors.black38, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              "Insert value for calculate",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          buildTextField(
                              "Real", "R\$ ", realController, _realChanged),
                          Divider(),
                          buildTextField("Dollar", "US\$ ", dollarController,
                              _dollarChanged),
                          Divider(),
                          buildTextField(
                              "Euro", "(€) ", euroController, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController con, Function f) {
  return TextField(
    controller: con,
    style: TextStyle(color: Colors.black38, fontSize: 18.0),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.black38,
        fontSize: 16.0,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
