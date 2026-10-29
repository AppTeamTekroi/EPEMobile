import 'package:flutter/cupertino.dart';

class ButtonBS extends StatelessWidget {
  final String title;
  final String? buttonText;
  final double? height;
  final double? width;
  final double? padding;
  final double? separatePrefixIcon;
  final double? separateSuffixIcon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final double? prefixIconSize;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final double? suffixIconSize;
  const ButtonBS({
    Key? key,
    required this.title,
    this.buttonText,
    this.height,
    this.width,
    this.padding,
    this.separatePrefixIcon,
    this.separateSuffixIcon,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
    this.borderRadius = 0,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixIconSize,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(padding??0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              prefixIcon,
              size: prefixIconSize,
              color: prefixIconColor,
            ),
            SizedBox(
              width: separatePrefixIcon,
            ),
            //suffix icons

            Text(
              title,
              style: TextStyle(
                  color: textColor, fontSize: fontSize, fontWeight: fontWeight),
            ),
            SizedBox(
              width: separateSuffixIcon,
            ),
            //suffix icons

            Icon(
              suffixIcon,
              size: suffixIconSize,
              color: suffixIconColor,
            )
          ],
        ),
      ),
    );
  }
}
