import 'package:freezed_annotation/freezed_annotation.dart';

part 'festival_meet.freezed.dart';
part 'festival_meet.g.dart';

@freezed
class FestivalMeet with _$FestivalMeet {

  const factory FestivalMeet({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required List<dynamic> members,
    required int limit,
    required String location,
    required String fee,
    required String manager
  }) = _FestivalMeet;

  factory FestivalMeet.fromJson(Map<String, Object?> json) => _$FestivalMeetFromJson(json);
}