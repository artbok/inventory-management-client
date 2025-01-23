import 'package:flutter/material.dart';

Widget pageChanger(int currentPage, int totalPages, VoidCallback nextPage,
    VoidCallback previousPage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () {
          if (currentPage != 1) {
            previousPage();
          }
        },
        child: const Icon(Icons.arrow_back_rounded),
      ),
      Text("   Страница $currentPage/$totalPages   "),
      InkWell(
          onTap: () {
            if (currentPage < totalPages) {
              nextPage();
            }
          },
          child: const Icon(Icons.arrow_forward_rounded))
    ],
  );
}
