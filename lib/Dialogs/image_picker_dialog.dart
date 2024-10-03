import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(XFile) onImageReceived;

  const ImagePickerDialog({super.key, required this.onImageReceived});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            getImagePath(ImageSource.camera);
          },
          leading: const Icon(
            Icons.camera_alt,
            color: Colors.black,
          ),
          title: const Text('Camera'),
        ),
        ListTile(
          onTap: () {
            getImagePath(ImageSource.gallery);
          },
          leading: const Icon(
            Icons.photo,
            color: Colors.black,
          ),
          title: const Text('Gallery'),
        )
      ],
    );
  }

  void getImagePath(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: source);
    if (file == null) return;
    onImageReceived(file);
  }
}
