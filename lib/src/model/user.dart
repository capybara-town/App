class User {
  final String pk;
  final String profileImage;
  final String name;
  final String belong;
  final String role;

  User({
    required this.pk,
    required this.profileImage,
    required this.name,
    required this.belong,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pk: json['pk'],
      profileImage: json['profile_image'],
      name: json['name'],
      belong: json['belong'],
      role: json['role']
    );
  }
}