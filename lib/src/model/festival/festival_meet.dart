import '../user.dart';

class FestivalMeet {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> members;
  final int limit;

  FestivalMeet({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.members,
    required this.limit
  });

  factory FestivalMeet.fromJson(Map<String, dynamic> json) {
    return FestivalMeet(
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date'].toDate().toString()),
      endDate: DateTime.parse(json['end_date'].toDate().toString()),
      members: json['members'],
      limit: json['limit']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'members': members,
      'limit': limit
    };
  }
}