import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yemekhane_app/core/models/upload_media_result.dart';

class DetailScreen extends StatelessWidget {
  final UploadMediaResult result;
  const DetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(result.className)],
        ),
      ),
    );
  }
}
