import 'dart:convert';

import 'package:vapp/models/shop.dart';

class Product {
  final int productId;
  final String name;
  final String imageUrl;
  final int cost;
  final String description;
  final int bablos;

  const Product({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.cost,
    required this.description,
    required this.bablos
  });
  Map<String, dynamic> toJson() => {
    'productId' : productId,
    'name' : name,
    'imageUrl' : imageUrl,
    'cost' : cost,
    'description': description,
    'bablos': bablos
  };
  factory Product.fromJson(Map<dynamic, dynamic> product) {
    return Product(
        productId: product['productId'],
        name: product['name'],
        imageUrl: product['imageUrl'],
        cost: product['cost'],
        description: product['description'],
        bablos: product['bablos']
    );
  }
}

class Shop {
  final int shopId;
  final String name;
  final String address;
  final List<Product> products;

  const Shop({
    required this.shopId,
    required this.products,
    required this.name,
    required this.address
  });
  Map<String, dynamic> toJson() => {
    'shopId': shopId,
    'products': products,
    'name' : name,
    'address' : address
  };
  factory Shop.fromJson(Map<dynamic, dynamic> jsonShop) {
    var list = jsonShop['products'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();
    return Shop(
      shopId: jsonShop['shopId'],
      name: jsonShop['name'],
      address: jsonShop['address'],
      products: productList
    );
  }
}