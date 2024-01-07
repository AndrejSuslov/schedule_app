import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contributor.g.dart';

/// {@template contributor}
/// The contributor github model.
/// {@endtemplate}
@JsonSerializable()
class Contributor extends Equatable {
  /// {@macro contributor}
  const Contributor({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.contributions,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) =>
      _$ContributorFromJson(json);

  final String login;

  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  @JsonKey(name: 'html_url')
  final String htmlUrl;

  final int contributions;

  Map<String, dynamic> toJson() => _$ContributorToJson(this);

  @override
  List<Object?> get props => [login, avatarUrl, htmlUrl, contributions];
}
