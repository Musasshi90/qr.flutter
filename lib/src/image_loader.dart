import 'package:flutter/widgets.dart';
import 'dart:ui' as sky;
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:typed_data';

class ImageLoader {

  static Future<sky.Image> load(String url) async {
    AssetBundle bundle = getAssetBundle();
    ByteData bd = await bundle.load(url);
    Uint8List lst = new Uint8List.view(bd.buffer);
    sky.Codec codec = await sky.instantiateImageCodec(lst);
    sky.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  static AssetBundle getAssetBundle() {
    if (rootBundle != null) {
      return rootBundle;
    } else {
      return new NetworkAssetBundle(new Uri.directory(Uri.base.origin));
    }
  }
}
