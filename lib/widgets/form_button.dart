import 'package:flutter/material.dart';
import 'package:survey_jys/constants/sizes.dart';

class FormButton extends StatelessWidget {
  FormButton({
    super.key,
    required this.disabled,
    required this.text,
    required this.widthSize,
  });

  final bool disabled;
  final String text;
  double widthSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthSize,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Sizes.size5,
          ),
          color:
              disabled ? Colors.grey.shade300 : Theme.of(context).primaryColor,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(microseconds: 300),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: disabled ? Colors.grey.shade400 : Colors.white,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
