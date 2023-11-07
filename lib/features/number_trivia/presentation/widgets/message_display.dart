import 'package:flutter/material.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/utils/width_height.dart';

class MessageDisplay extends StatelessWidget {
  String message;
  Color color;

  MessageDisplay({
    required this.message,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Text(
          message,
          style: TextStyle(
            fontSize: wd(context) * 0.06,
            fontFamily: "GameFamily",
            color: color,
            fontWeight: FontWeight.w500
          )
        ),
      ),
    );
  }
}
