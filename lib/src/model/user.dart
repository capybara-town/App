class User {
  final String uid;
  final String profileImage;
  final String name;
  final String nickname;
  final String belong;
  final String role;
  final List<dynamic> interest;
  final List<dynamic> personality;

  User({
    required this.uid,
    required this.profileImage,
    required this.name,
    required this.nickname,
    required this.belong,
    required this.role,
    required this.interest,
    required this.personality
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      profileImage: json['profile_image'],
      name: json['name'],
      nickname: json['nickname'],
      belong: json['belong'],
      role: json['role'],
      interest: json['interest'],
      personality: json['personality']
    );
  }
}