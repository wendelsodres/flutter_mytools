import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {

  final List<dynamic> _productData;
  ProductDetail(this._productData); 

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {  

  @override
  void initState() {
    super.initState();

    print('widget._productData[0]');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(        
        children: <Widget>[          
          //Text(widget._productData),         
          
        ],
      ),
    );
    
  }

  
}
