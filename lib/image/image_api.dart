abstract class ImageApi {
  static const int MIN_SIZE = 300;
  static const int MAX_SIZE = 1024;

  void shuffle();

  String getImageUrl();
}
