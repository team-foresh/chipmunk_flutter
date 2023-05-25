import 'package:flutter/cupertino.dart';

import 'sahttering-widget.dart';

class StackThing {
  final Offset position;
  final Matrix4 transform;
  final String imgPath;
  final double imgHeight;

  StackThing(this.position, this.transform, this.imgPath, this.imgHeight);
}

class StackThingWidget extends StatelessWidget {
  final StackThing stackThing;
  final void Function() onTap;

  const StackThingWidget({required Key key, required this.stackThing, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
        left: stackThing.position.dx,
        top: stackThing.position.dy,
        child: ShatteringWidget(
          builder: (shatter) => GestureDetector(
              child: Transform(
                transform: stackThing.transform,
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(stackThing.imgPath),
                  height: stackThing.imgHeight,
                ),
              ),
              onTap: shatter),
          onShatterCompleted: onTap,
          key: UniqueKey(),
        ),
      );
}
