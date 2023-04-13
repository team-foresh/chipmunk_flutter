import 'dart:io';

import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChipmunkImagePicker {
  static const String _tag = "[FortuneImagePicker]";

// 이미지 가져오기.
  void loadImagePicker(Function1 onLoad, Function0 onError) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        String? path = await _cropImageAndGetFilePath(image.path);
        if (path != null) {
          onLoad(path);
        }
      } else {
        ChipmunkLogger.debug(tag: _tag, "프로필 이미지 불러오기 실패.");
      }
    } on PlatformException catch (e) {
      PermissionStatus result;
      if (Platform.isAndroid) {
        result = await Permission.storage.request();
      } else {
        result = await Permission.photos.request();
      }
      if (!result.isGranted) {
        onError();
      } else {
        loadImagePicker(onLoad, onError);
      }
    }
  }

  // 이미지 자르기
  _cropImageAndGetFilePath(String imagePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imagePath, // 이미지 경로
      maxWidth: 1920, // 이미지 최대 너비
      maxHeight: 1080, // 이미지 최대 높이
      compressQuality: 75, // 이미지 압축 품질
    );

    return croppedImage?.path;
  }
}
