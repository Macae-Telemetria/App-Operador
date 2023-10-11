import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String initialValue;

  const AppTextField(
      {super.key,
      required this.label,
      required this.initialValue,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          onTapOutside: (v) => {FocusScope.of(context).unfocus()},
          maxLines: 1,
          textAlign: TextAlign.left,
          controller: controller,
          style: TextStyle(fontSize: 16.0, height: .7, color: Colors.black54),
          decoration: const InputDecoration(
              hintText: "Digite aqui",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
