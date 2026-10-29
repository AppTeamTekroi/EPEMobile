import 'package:flutter/material.dart';
import 'package:sap/ui/color/appColor.dart';

class CommonRichText extends StatelessWidget {
  final String label;
  final String value;

  const CommonRichText({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: '$label',
        style: TextStyle(color: AppColors.mainblue, fontWeight: FontWeight.bold, fontSize: 15),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(color: Colors.black87,fontWeight: FontWeight.normal,fontSize: 13),
          ),
        ],
      ),
    );
  }
}
