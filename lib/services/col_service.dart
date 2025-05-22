import 'dart:convert';
import 'package:http/http.dart' as http;

class ColService{
  Future<String> findCitySlug(String cityName) async {
    final uri = Uri.parse(
        'https://api.teleport.org/api/cities/?search=${Uri.encodeComponent(cityName)}&limit=1'
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch city slug: ${resp.statusCode}');

    }

    final data = jsonDecode(resp.body);
    final item = (data['_embedded']['city:search-results'] as List).first;
    final href = item['_links']['city:item']['href'] as String;
    final slug = href.split('/').reversed.skip(1).first;
    return slug;
  }

  Future<Map<String, double>> fetchCostOfLiving(String citySlug) async {
    final uri = Uri.parse(
        'https://api.teleport.org/api/urban_areas/slug:$citySlug/cost-of-living/'
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch cost of living: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body);
    final categories = data['categories'] as List;

    final Map<String, double> averages = {};
    for (var cat in categories) {
      final name = cat['label'] as String;
      final cost = (cat['data'] as List).firstWhere((d) => d['currency_dollar_value']!=null)['currency_dollar_value'] as num;
      averages[name] = cost.toDouble();

    }
    return averages;


  }
}