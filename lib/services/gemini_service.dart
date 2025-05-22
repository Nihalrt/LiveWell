// lib/services/gemini_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // 1) Read your API key from .env
  final String _apiKey = dotenv.env['GEMINI_API_KEY']!;

  /// Call this once (e.g. in initState) to see which models your key supports.
  Future<void> listModels() async {
    final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models'
    ).replace(queryParameters: {'key': _apiKey});

    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      debugPrint('List models failed ${resp.statusCode}: ${resp.body}');
      return;
    }
    debugPrint('Available Gemini models: ${resp.body}');
  }

  /// The v1beta endpoint for the gemini-2.0-flash model, matching AI Studio’s curl.
  Uri get _endpoint => Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent'
  ).replace(queryParameters: {
    'key': _apiKey,
  });

  /// Returns a list of tips. If no bullet lines are found, returns the full response.
  Future<List<String>> getRecommendations({
    required String location,
    required double salary,
    required Map<String, double> expenses,
    required int householdSize,
    required String ageBracket,
  }) async {
    // a) Build the prompt
    final prompt = StringBuffer()
      ..writeln('You are a friendly personal finance coach.')
      ..writeln('User profile:')
      ..writeln('- Location: $location')
      ..writeln('- Salary: \$${salary.toStringAsFixed(2)}')
      ..writeln('- Household size: $householdSize, Age: $ageBracket')
      ..writeln('- Expenses:')
      ..writeAll(expenses.entries.map(
            (e) => '  • ${e.key}: \$${e.value.toStringAsFixed(2)}',
      ))
      ..writeln('\nAssess if this budget is feasible.')
      ..writeln('Then provide 5 concise, actionable tips as bullet points.');

    // b) Send the HTTP POST
    final response = await http.post(
      _endpoint,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt.toString()}
            ]
          }
        ]
      }),
    );

    // c) Handle HTTP errors
    if (response.statusCode != 200) {
      throw Exception('Gemini API error ${response.statusCode}: ${response.body}');
    }

    // d) Decode the JSON and extract the first candidate
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidate = (data['candidates'] as List).first as Map<String, dynamic>;

    // e) Extract the text from candidate['content']['parts']
    final content = candidate['content'];
    String outputText;
    if (content is Map && content['parts'] is List) {
      final parts = content['parts'] as List;
      outputText = parts
          .map((p) => p['text'] as String)
          .join();
    } else {
      throw Exception('Unexpected content format: $content');
    }

    // f) Debug-print the raw output so you can see its exact format
    debugPrint('Gemini raw output:\n$outputText');

    // g) Try to split into bullet lines
    final lines = outputText
        .split(RegExp(r'\r?\n'))
        .where((l) {
      final t = l.trim();
      return t.startsWith('•') || t.startsWith('-');
    })
        .map((l) => l.trim().replaceFirst(RegExp(r'^[•\-]\s*'), ''))
        .toList();

    // h) Fallback: if no bullet lines found, return the full text as a single entry
    if (lines.isEmpty) {
      return [outputText.trim()];
    }

    return lines;
  }
}
