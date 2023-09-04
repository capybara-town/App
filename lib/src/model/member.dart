import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
class Member with _$Member {

  const factory Member({
    required String uid,
    required String profileImage,
    required String name,
    required String nickname,
    required String belong,
    required String role,
    required List<dynamic> interest,
    required List<dynamic> personality,
    required List<dynamic> follower,
    required List<dynamic> following,
    required String introduceLink
  }) = _Member;

  factory Member.fromJson(Map<String, Object?> json) => _$MemberFromJson(json);
}