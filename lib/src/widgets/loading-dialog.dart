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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 28,
            ),
            Container(
              width: 52.0,
              height: 52.0,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 5.0,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              subtitle ?? "",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
