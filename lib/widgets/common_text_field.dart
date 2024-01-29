import 'package:flutter/material.dart';
import 'package:flutter_test_project/widgets/typography.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.maxLines,
    this.controller,
    this.suffixIcon,
    this.readOnly = false,
  });

  final String title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool readOnly;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Style.bodyL,
        ),
        TextField(
          readOnly: readOnly,
          controller: controller,
          maxLines: maxLines,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
              hintStyle: Style.bodyL),
          onChanged: (value) {},
        )
      ],
    );
  }
}
