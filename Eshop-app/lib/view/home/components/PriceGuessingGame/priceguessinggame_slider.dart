import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:eshop/service/remote_service/remote_product_service.dart';
import 'package:eshop/model/product.dart';

class PriceGuessingGame extends StatefulWidget {
  @override
  _PriceGuessingGameState createState() => _PriceGuessingGameState();
}

class _PriceGuessingGameState extends State<PriceGuessingGame> {
  final RemoteProductService productService = RemoteProductService();
  List<Product> allProducts = [];
  List<Product> selectedProducts = [];
  List<double?> selectedPrices = List.filled(10, null);

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    try {
      List<Product> products = await productService.fetchProduct();
      setState(() {
        allProducts = products;
        selectedProducts = _selectRandomProducts(products, 10);
      });
    } catch (error) {
      print('Error fetching product data: $error');
    }
  }

  List<Product> _selectRandomProducts(List<Product> products, int count) {
    final random = Random();
    List<Product> selected = [];
    while (selected.length < count && products.isNotEmpty) {
      int index = random.nextInt(products.length);
      selected.add(products.removeAt(index));
    }
    return selected;
  }

  void _submitAnswers() {
    int correctAnswers = 0;
    for (int i = 0; i < selectedProducts.length; i++) {
      if (selectedPrices[i] == selectedProducts[i].price) {
        correctAnswers++;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Result'),
        content: Text('You got $correctAnswers out of 10 correct!'),
        actions: [
          TextButton(
          onPressed: () {
    Navigator.of(context).pop();
    _resetGame();
    if (correctAnswers == 10) {
    Navigator.pushNamed(context, '/spinWheel');
    }
    },
      child: Text('OK'),
    ),

        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      selectedPrices = List.filled(10, null);
      selectedProducts = _selectRandomProducts(List.from(allProducts), 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Guessing Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: allProducts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: selectedProducts.length,
        itemBuilder: (context, index) {
          Product product = selectedProducts[index];
          List<double> priceOptions = [
            product.price,
            product.price * 0.9,
            product.price * 1.1,
          ]..shuffle();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select the correct price for ${product.name}',
                    style: TextStyle(fontSize: 18),
                  ),
                  ...priceOptions.map((price) {
                    return ListTile(
                      title: Text('$price VND'),
                      leading: Radio<double>(
                        value: price,
                        groupValue: selectedPrices[index],
                        onChanged: (value) {
                          setState(() {
                            selectedPrices[index] = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _submitAnswers,
              child: Icon(Icons.check),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 86,
            child: FloatingActionButton(
              onPressed: _resetGame,
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: PriceGuessingGame(),
));
