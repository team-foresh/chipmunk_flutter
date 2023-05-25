import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animated List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAnimatedList(key: GlobalKey()),
    );
  }
}

class MyAnimatedList extends StatefulWidget {
  MyAnimatedList({required Key? key}) : super(key: key);

  @override
  _MyAnimatedListState createState() => _MyAnimatedListState();
}

class _MyAnimatedListState extends State<MyAnimatedList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  void _addItem() {
    setState(() {
      _items = ['New Item', ..._items];
      _listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 1000));
    });
  }

  Widget _createItem(BuildContext context, String item, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated List')),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _createItem(context, _items[index], animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
