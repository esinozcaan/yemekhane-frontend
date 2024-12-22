import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, int> result;

  const DetailScreen({super.key, required this.result});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //widget.result["Test"] = 1;
      //widget.result["Test2"] = 2;
      //setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 127, 117, 27),
        title: Text('Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: widget.result.entries.map((e) {
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                title: Text(
                  e.key,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 56, 66, 6)),
                ),
                subtitle: Text(
                  'Adet: ${e.value}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
