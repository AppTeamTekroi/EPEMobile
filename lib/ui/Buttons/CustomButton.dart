import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Widget? buttonText;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onPressed;
  EdgeInsetsGeometry? innerPadding;
  CustomButton({
    Key? key,
    required this.title,
    this.buttonText,
    this.height,
    this.width,
    this.backgroundColor,
    this.onPressed,
    this.borderRadius = 0,
    this.innerPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //suffix icons

            Padding(
                padding: innerPadding ?? const EdgeInsets.all(0),
                child: buttonText),
          ],
        ),
      ),
    );
  }

}
