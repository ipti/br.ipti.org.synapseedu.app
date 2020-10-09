import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 0);

class Activities extends StatelessWidget {
  _buildPageView(int index, BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final count = watch(counterProvider).state;
      return PageView(
        scrollDirection: Axis.vertical,
        children: [
          Center(child: Text('Page ${count + 1}')),
          Center(child: Text('Page $count')),
        ],
      );
    });
    // child: PageView(
    //   scrollDirection: Axis.vertical,
    //   children: [
    //     Center(child: Text('Page ${index + 1}')),
    //     Center(child: Text('Page $index')),
    //   ],
    // ),
    // ),
  }

  @override
  Widget build(BuildContext context) {
    // double _halfHeight = MediaQuery.of(context).size.height / 2;
    int index = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elesson',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => {context.read(counterProvider).state++},
          )
        ],
      ),
      body: _buildPageView(index, context),
    );
  }
}
