import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  final String? subtitle;

  const LoadingDialog({super.key, this.title = 'Carregando', this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            Text(
              subtitle ?? "",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
