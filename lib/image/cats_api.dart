import 'dart:math';

import 'image_api.dart';

class CatsApi extends ImageApi {
  String _url;

  @override
  String getImageUrl() {
    return _url;
  }

  @override
  void shuffle() {
    Random random = Random();
    int randSize = ImageApi.MIN_SIZE + random.nextInt(ImageApi.MAX_SIZE - ImageApi.MIN_SIZE);
    _url = "http://placekitten.com/$randSize";
  }
}
