import '../user.dart';

class Meet {
  final String pk;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final List<String> members;
  final int limit;

  Meet({
    required this.pk,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.members,
    required this.limit
  });

  factory Meet.fromJson(Map<String, dynamic> json) {
    return Meet(
      pk: json['pk'],
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      members: json['members'],
      limit: json['limit']
    );
  }
}