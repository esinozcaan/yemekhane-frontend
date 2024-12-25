import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:yemekhane_app/core/models/upload_media_result.dart';

class DetailScreen extends StatefulWidget {
  final ResponseModel result;

  const DetailScreen({super.key, required this.result});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Items? items;
  late Menu? menu;
  late String? annotatedImagePath;
  late String? error;
  late int? savings;
  late double? savingsPercent;

  @override
  void initState() {
    super.initState();
    final data = widget.result;
    items = data.items;
    menu = data.menu;

    // Savings and savings percent
    savings = data.savings;
    savingsPercent = data.savings_percent;
    print(savingsPercent);

    // Tam URL oluşturuluyor
    const baseUrl = 'http://192.168.158.47:3001'; // Backend'inizin URL'si
    annotatedImagePath = data.annotatedImagePath != null
        ? '$baseUrl/${data.annotatedImagePath}'
        : null;

    error = data.error;
  }

  String formatText(String text) {
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 127, 117, 27),
        title: const Text('Details'),
      ),
      body: items != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        title: Text(
                          'Total Calories: ${items!.totalCalories}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 56, 66, 6),
                          ),
                        ),
                        subtitle: Text(
                          'Total Price: ${items!.totalPrice} TL',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Menu Gösterimi (eğer varsa)
                    if (menu != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Savings and Savings Percent Section
                          Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              title: const Text(
                                'Savings Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 56, 66, 6),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Savings: ${savings} TL'),
                                  Text(
                                    'Savings Percent: ${savingsPercent?.toStringAsFixed(2)}%',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Menu Section
                          Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              title: Text(
                                'Menu: ${formatText(menu!.name)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 56, 66, 6),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Description: ${formatText(menu!.description)}'),
                                  Text('Price: ${menu!.price} TL'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    // Annotated Image Display
                    if (annotatedImagePath != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.network(
                          annotatedImagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                  child: Text('Image could not be loaded')),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Result List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items!.result.length,
                      itemBuilder: (context, index) {
                        final item = items!.result[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            title: Text(
                              formatText(item.name),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 56, 66, 6),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Calories: ${item.calories}'),
                                Text('Price: ${item.price} TL'),
                                Text('Count: ${item.count}'),
                                Text('Category: ${formatText(item.category)}'),
                                if (item.type != null && item.type!.isNotEmpty)
                                  Text('Type: ${formatText(item.type!)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: error != null
                  ? Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                  : const CircularProgressIndicator(),
            ),
    );
  }
}
