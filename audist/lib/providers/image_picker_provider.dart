import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _firstImage;
  File? _secondImage;

  File? get firstImage => _firstImage;
  File? get secondImage => _secondImage;

  void setFirstImage(File? file) {
    _firstImage = file;
    notifyListeners();
  }

  void setSecondImage(File? file) {
    _secondImage = file;
    notifyListeners();
  }

  // Pick first image (used by one interface)
  Future<void> pickFirstImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      _firstImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickFirstImageFromFilePicker() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      _firstImage = File(result.files.single.path!);
      notifyListeners();
    }
  }

  // Pick second image (used by another interface)
  Future<void> pickSecondImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      _secondImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickSecondImageFromFilePicker() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      _secondImage = File(result.files.single.path!);
      notifyListeners();
    }
  }

  void clearFirstImage() {
    _firstImage = null;
    notifyListeners();
  }

  void clearSecondImage() {
    _secondImage = null;
    notifyListeners();
  }
}