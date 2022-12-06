import 'package:assignment/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Assignment 2",
    theme: ThemeData(
      primarySwatch: Colors.orange
    ),
    home: const HomePage(),
  ));
}
