import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image/billmurray_api.dart';
import 'image/cats_api.dart';
import 'image/image_api.dart';
import 'image/picsum_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyTabbedPage());
  }
}

class MyTabbedPage extends StatelessWidget {
  MyTabbedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Kitties",
              ),
              Tab(
                text: "Bill Murray",
              ),
              Tab(
                text: "Random",
              )
            ],
          ),
          title: Text("Cats & more"),
        ),
        body: TabBarView(
          children: [
            MyTab("To brighten your day", CatsApi()),
            MyTab("In case you needed to see Bill Murray", BillMurrayApi()),
            MyTab("Some random pics with no correlation", PicsumApi()),
          ],
        ),
      ),
    );
  }
}

class MyTab extends StatefulWidget {
  final String _title;
  final ImageApi _api;

  MyTab(this._title, this._api);

  @override
  _MyTabState createState() => _MyTabState(_title, _api);
}

class _MyTabState extends State<MyTab> with AutomaticKeepAliveClientMixin {
  final String _title;
  final ImageApi _api;
  String _currentUrl = "";
  final double dragSpeedThreshold = 2100;

  _MyTabState(this._title, this._api) {
    _shuffleAndUpdate();
  }

  void _handleDrag(DragEndDetails details) {
    print("Drag velocity: ${details.velocity.pixelsPerSecond.dx.abs().floor()}");
    if (details.velocity.pixelsPerSecond.dx.abs().floor() >= dragSpeedThreshold) {
      _updateUrl();
    }
  }

  void _updateUrl() {
    setState(() {
      _shuffleAndUpdate();
    });
  }

  void _shuffleAndUpdate() {
    _api.shuffle();
    _currentUrl = _api.getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildImageContainer(), _buildImageTitle(), _buildImageSubtitle()],
      ),
    );
  }

  Text _buildImageSubtitle() => Text("(Swipe on the image to see more pictures)");

  Padding _buildImageTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        this._title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  GestureDetector _buildImageContainer() {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 3.0, style: BorderStyle.solid),
          ),
          child: _loadCurrentImage(),
        ),
        onHorizontalDragEnd: _handleDrag);
  }

  Image _loadCurrentImage() {
    return Image.network(
      _currentUrl,
      width: ImageApi.MIN_SIZE.toDouble(),
      height: ImageApi.MIN_SIZE.toDouble(),
      fit: BoxFit.cover,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
