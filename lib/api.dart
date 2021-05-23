import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'models/locations.dart';

class Api {
  static Future<Locations?> fetchOffices(VoidCallback onError) async {
    try {
      final url = 'https://about.google/static/data/locations.json';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Locations.fromJson(json.decode(response.body));
      } else {
        onError();
      }
    } catch (e) {
      onError();
    }
    return null;
  }
}
