import 'dart:ffi';

class Menu {
  final String name;
  final String description;
  final int price;

  Menu({required this.name, required this.description, required this.price});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }
}

class ResultExpandedItem {
  final String name;
  final int calories;
  final int price;
  final int count;
  final String category;
  final String? type;

  ResultExpandedItem({
    required this.name,
    required this.calories,
    required this.price,
    required this.count,
    required this.category,
    this.type,
  });

  factory ResultExpandedItem.fromJson(Map<String, dynamic> json) {
    return ResultExpandedItem(
      name: json['name'],
      calories: json['calories'],
      price: json['price'],
      count: json['count'],
      category: json['category'],
      type: json['type'],
    );
  }
}

class Items {
  final int totalCalories;
  final int totalPrice;
  final List<ResultExpandedItem> result;

  Items({
    required this.totalCalories,
    required this.totalPrice,
    required this.result,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      totalCalories: json['total_calories'],
      totalPrice: json['total_price'],
      result: (json['result'] as List)
          .map((item) => ResultExpandedItem.fromJson(item))
          .toList(),
    );
  }
}

class ResponseModel {
  final Items? items;
  final Menu? menu;
  final String? annotatedImagePath;
  final String? error;
  final int? savings;
  final double? savings_percent;

  ResponseModel(
      {this.items,
      this.menu,
      this.annotatedImagePath,
      this.error,
      this.savings,
      this.savings_percent});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      items: json['items'] != null ? Items.fromJson(json['items']) : null,
      menu: json['menu'] != null ? Menu.fromJson(json['menu']) : null,
      annotatedImagePath: json['annotated_image_path'],
      savings: json["savings"],
      savings_percent: json["savings_percent"],
      error: json['error'],
    );
  }
}
