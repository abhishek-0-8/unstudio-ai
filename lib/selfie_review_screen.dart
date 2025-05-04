import 'dart:io';
import 'package:flutter/material.dart';

class SelfieReviewScreen extends StatelessWidget {
  final List<File> images;

  const SelfieReviewScreen({required this.images, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Selfies")),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(images[index]),
          );
        },
      ),
    );
  }
}
