import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDisplayScreen extends StatelessWidget {
  static const String id = 'Image_Display_Screen';
  final String imageUrl;

  const ImageDisplayScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
