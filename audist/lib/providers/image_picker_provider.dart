import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {
  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      _pickedImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickImageFromFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      _pickedImage = file;
      notifyListeners();
    }
  }

  void clearImage() {
    _pickedImage = null;
    notifyListeners();
  }
}