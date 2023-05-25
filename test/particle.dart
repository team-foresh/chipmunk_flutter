import 'package:flutter/material.dart';

import 'destination.dart';
import 'sahttering-widget.dart';
import 'stack-thing-widget.dart';

void main() {
  runApp(ShatteringApp());
}

class ShatteringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shattering Widgets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShatteringHome(),
    );
  }
}

class ShatteringHome extends StatefulWidget {
  @override
  ShatteringHomeState createState() => ShatteringHomeState();
}

class ShatteringHomeState extends State<ShatteringHome> {
  bool destroyed = false;
  List<Destination> destinations = [
    Destination(
        "hawaii", "assets/icons/box1.gif", "Beautiful beaches. Volcanoes. Luau. What more could you possibly ask for?"),
    Destination("Mars", "assets/icons/box1.gif",
        "Inhospitable and austere. You'll probably die. Takes like 2 years to get there. No food. Enjoy!"),
    Destination("Heaven", "assets/icons/box1.gif", "Pretty nice place, but you have to die in order to get there."),
    Destination("Texas", "assets/icons/box1.gif", "Nice weather. Good food. Big. It's a place you should visit eventually."),
    Destination("Tourian", "assets/icons/box1.gif",
        "Pretty nice place, except there's metroids everywhere that will suck your energy out."),
    Destination("Mt Everest", "assets/icons/box1.gif",
        "Super tall mountain. Very low on oxygen. Take a sherpa with you or you'll probably wind up an ice block."),
    Destination("Angel Falls", "assets/icons/box1.gif",
        "You want to watch water come down from a really really really high place. Come to Venezuela!")
  ];

  List<StackThing> stackStuff = [
    StackThing(Offset(200, 400), Matrix4.rotationZ(.3), "assets/icons/box1.gif", 75),
    StackThing(Offset(100, 70), Matrix4.rotationZ(-1.3), "assets/icons/box1.gif", 200),
    StackThing(Offset(220, 20), Matrix4.rotationZ(1.5), "assets/icons/box1.gif", 50),
    StackThing(Offset(5, 400), Matrix4.rotationZ(3.6), "assets/icons/box1.gif", 50),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = [];
    if (stackStuff.isNotEmpty) {
      listItems.add(Container(
          height: 500,
          child: Stack(
              children: stackStuff
                  .map(
                    (e) => StackThingWidget(
                      stackThing: e,
                      onTap: () {
                        setState(() {
                          stackStuff.remove(e);
                        });
                      },
                      key: UniqueKey(),
                    ),
                  )
                  .toList())));
    }
    listItems.addAll(destinations.map((e) => ShatteringWidget(
          builder: (shatter) => DestinationCard(
            destination: e,
            onTrashTapped: () {
              shatter();
            },
            key: UniqueKey(),
          ),
          onShatterCompleted: () {
            // setState(() {
            //   destinations.remove(e);
            // });
          },
          key: UniqueKey(),
        )));
    return destroyed
        ? Scaffold(backgroundColor: Colors.black)
        : ShatteringWidget(
            builder: (shatter) => Scaffold(
              body: ListView(children: listItems),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.warning),
                onPressed: shatter,
              ),
            ),
            onShatterCompleted: () {
              // setState(() {
              //   destroyed = true;
              // });
            },
            key: UniqueKey(),
          );
  }
}
