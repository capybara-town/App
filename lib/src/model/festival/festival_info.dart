class FestivalInfo {
  final String pk;
  final String category;
  final String thumbnail;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String summary;
  final String description;
  final String location;
  final String locationName;
  final int fee;
  final List<dynamic> member;
  final List<dynamic> meets;
  final List<dynamic> descriptionImage;

  FestivalInfo({
    required this.pk,
    required this.category,
    required this.thumbnail,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.summary,
    required this.description,
    required this.location,
    required this.locationName,
    required this.fee,
    required this.member,
    required this.meets,
    required this.descriptionImage
  });

  factory FestivalInfo.fromJson(Map<String, dynamic> json) {
    return FestivalInfo(
      pk: json['pk'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      startDate: DateTime.parse(json['start_date'].toDate().toString()),
      endDate: DateTime.parse(json['end_date'].toDate().toString()),
      summary: json['summary'],
      description: json['description'],
      location: json['location'],
      locationName: json['location_name'],
      fee: json['fee'],
      member: json['member'].toList(),
      meets: json['meets'].toList(),
      descriptionImage: json['description_image'].toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pk": pk,
      "category": category,
      "thumbnail": thumbnail,
      "title": title,
      "start_date": startDate,
      "end_date": endDate,
      "summary": summary,
      "description": description,
      "location": location,
      "location_name": locationName,
      "fee": fee,
      "member": member,
      "meets": meets,
      "description_image": descriptionImage
    };
  }
}