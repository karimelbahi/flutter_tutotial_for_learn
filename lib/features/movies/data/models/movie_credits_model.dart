import '../../domain/entities/cast_member.dart';

/// Parses TMDB `/movie/{id}/credits` response.
class MovieCreditsModel {
  const MovieCreditsModel({required this.cast});

  final List<CastMemberModel> cast;

  factory MovieCreditsModel.fromJson(Map<String, dynamic> json) {
    final castJson = json['cast'] as List<dynamic>? ?? const [];
    return MovieCreditsModel(
      cast: castJson
          .map((item) => CastMemberModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  List<CastMember> toEntities() {
    return cast.map((model) => model.toEntity()).toList();
  }
}

class CastMemberModel {
  const CastMemberModel({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  final int id;
  final String name;
  final String character;
  final String? profilePath;

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }

  CastMember toEntity() {
    return CastMember(
      id: id,
      name: name,
      character: character,
      profilePath: profilePath,
    );
  }
}
