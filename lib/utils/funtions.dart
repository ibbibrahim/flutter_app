import 'package:html/parser.dart' as html_parser;
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility function to parse an HTML string and return plain text
String parseHtmlString(String htmlString) {
  final document = html_parser.parse(htmlString);
  return document.body?.text ?? '';
}

/// Utility function to generate MD5 hash for a given secret key and current date
String generateMd5Hash(String input) {
  // Generate MD5 hash and convert it to an uppercase string
  return md5.convert(utf8.encode(input)).toString();
}
