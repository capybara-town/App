import '../user.dart';

class FestivalMember {
  final pk;
  final List<User> members;

  FestivalMember({
    required this.pk,
    required this.members
  });

  factory FestivalMember.fromJson(Map<String, dynamic> json) {
    return FestivalMember(
      pk: json['pk'],
      members: json['members']
    );
  }
}