import 'package:flutter/material.dart';
const textField = InputDecoration(
  labelText: 'Enter a value',
  filled: true,
  fillColor: Colors.transparent,
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0.5,color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(width: 2.0,color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide( width: 2.0,color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);