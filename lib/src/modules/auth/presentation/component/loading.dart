import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidget();
}

class _LoadingWidget extends State<LoadingWidget> {

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        child: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: Colors.teal,
            size: 50,
          ),
        ),
      )
    );

  }
}