import 'package:flutter/material.dart';

class Failure{
  final String message;
  final int statusCode;

  Failure({this.message,@required this.statusCode});
}