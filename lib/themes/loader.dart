import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, this.opacity = 0.5, this.dismissibles = false, this.color = Colors.black}) : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        const Center(child: CupertinoActivityIndicator(animating: true, radius: 12, color: Colors.white)),
      ],
    );
  }
}
