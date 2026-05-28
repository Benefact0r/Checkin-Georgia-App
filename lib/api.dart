import 'dart:convert';
import 'package:http/http.dart' as http;

const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue:
      'https://checkin-georgia-api-171625154738.europe-west1.run.app',
);

enum Vertical { salon, restaurant, cafe, bar }

extension VerticalX on Vertical {
  String get apiValue => name;
  String get label => switch (this) {
        Vertical.salon => 'სალონები',
        Vertical.restaurant => 'რესტორნები',
        Vertical.cafe => 'კაფეები',
        Vertical.bar => 'ბარები',
      };
}

Vertical _parseVertical(String s) =>
    Vertical.values.firstWhere((v) => v.apiValue == s);

class Venue {
  Venue({
    required this.id,
    required this.slug,
    required this.name,
    required this.vertical,
    required this.description,
    required this.address,
    required this.city,
    required this.coverUrl,
    required this.photos,
    required this.lat,
    required this.lng,
  });

  final String id;
  final String slug;
  final String name;
  final Vertical vertical;
  final String? description;
  final String address;
  final String city;
  final String? coverUrl;
  final List<String> photos;
  final double? lat;
  final double? lng;

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json['id'] as String,
        slug: json['slug'] as String,
        name: json['name'] as String,
        vertical: _parseVertical(json['vertical'] as String),
        description: json['description'] as String?,
        address: json['address'] as String,
        city: json['city'] as String,
        coverUrl: json['cover_url'] as String?,
        photos: ((json['photos'] as List?) ?? const [])
            .map((e) => e as String)
            .toList(),
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
      );
}

class Resource {
  Resource({
    required this.id,
    required this.name,
    required this.kind,
    required this.capacity,
    required this.bio,
  });
  final String id;
  final String name;
  final String kind;
  final int capacity;
  final String? bio;

  factory Resource.fromJson(Map<String, dynamic> j) => Resource(
        id: j['id'] as String,
        name: j['name'] as String,
        kind: j['kind'] as String,
        capacity: j['capacity'] as int,
        bio: j['bio'] as String?,
      );
}

class Service {
  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.durationMinutes,
    required this.priceMinor,
    required this.currency,
  });
  final String id;
  final String name;
  final String? description;
  final String? category;
  final int? durationMinutes;
  final int? priceMinor;
  final String currency;

  String get formattedPrice {
    if (priceMinor == null) return '—';
    return '${(priceMinor! / 100).toStringAsFixed(0)} $currency';
  }

  factory Service.fromJson(Map<String, dynamic> j) => Service(
        id: j['id'] as String,
        name: j['name'] as String,
        description: j['description'] as String?,
        category: j['category'] as String?,
        durationMinutes: j['duration_minutes'] as int?,
        priceMinor: j['price_minor'] is String
            ? int.parse(j['price_minor'] as String)
            : j['price_minor'] as int?,
        currency: (j['currency'] as String?) ?? 'GEL',
      );
}

class VenueDetail extends Venue {
  VenueDetail({
    required super.id,
    required super.slug,
    required super.name,
    required super.vertical,
    required super.description,
    required super.address,
    required super.city,
    required super.coverUrl,
    required super.photos,
    required super.lat,
    required super.lng,
    required this.resources,
    required this.services,
    required this.avgRating,
    required this.reviewCount,
  });

  final List<Resource> resources;
  final List<Service> services;
  final double? avgRating;
  final int reviewCount;

  factory VenueDetail.fromJson(Map<String, dynamic> j) => VenueDetail(
        id: j['id'] as String,
        slug: j['slug'] as String,
        name: j['name'] as String,
        vertical: _parseVertical(j['vertical'] as String),
        description: j['description'] as String?,
        address: j['address'] as String,
        city: j['city'] as String,
        coverUrl: j['cover_url'] as String?,
        photos: ((j['photos'] as List?) ?? const [])
            .map((e) => e as String)
            .toList(),
        lat: (j['lat'] as num?)?.toDouble(),
        lng: (j['lng'] as num?)?.toDouble(),
        resources: ((j['resources'] as List?) ?? const [])
            .map((e) => Resource.fromJson(e as Map<String, dynamic>))
            .toList(),
        services: ((j['services'] as List?) ?? const [])
            .map((e) => Service.fromJson(e as Map<String, dynamic>))
            .toList(),
        avgRating: (j['avg_rating'] as num?)?.toDouble(),
        reviewCount: (j['review_count'] as int?) ?? 0,
      );
}

class CheckinApi {
  CheckinApi({this.baseUrl = kApiBaseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  void dispose() => _client.close();

  Future<List<Venue>> listVenues({Vertical? vertical, int limit = 30}) async {
    final params = <String, String>{'limit': '$limit'};
    if (vertical != null) params['vertical'] = vertical.apiValue;
    final uri = Uri.parse('$baseUrl/venues').replace(queryParameters: params);
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('listVenues failed: ${res.statusCode} ${res.body}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['items'] as List)
        .map((e) => Venue.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VenueDetail> getVenue(String slug) async {
    final uri = Uri.parse('$baseUrl/venues/$slug');
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('getVenue failed: ${res.statusCode} ${res.body}');
    }
    return VenueDetail.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
